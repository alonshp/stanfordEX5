//
//  ViewController.swift
//  Image Gallery
//
//  Created by Alon Shprung on 4/1/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDropDelegate, UICollectionViewDragDelegate, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        // add pinch gesture
        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(self.changeImagesWidth(_:)))
        self.view.addGestureRecognizer(pinchGesture)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var galleryName: String?
    var mapImageURLToUIImage = [URL : UIImage]()
    
    private var currImagesWidth = 400.0
    private var lastImageRatio: Double?
    
    
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    var imageFetcher: ImageFetcher!

    @IBOutlet weak var imageGalleryView: UICollectionView! {
        didSet {
            imageGalleryView.dataSource = self
            imageGalleryView.delegate = self
            imageGalleryView.dragDelegate = self
            imageGalleryView.dropDelegate = self
        }
    }
    
    @objc func changeImagesWidth(_ sender: UIPinchGestureRecognizer) {
        currImagesWidth = currImagesWidth * Double(sender.scale)
        if currImagesWidth < 100 {
            currImagesWidth = 100
        } else if currImagesWidth > 600 {
            currImagesWidth = 600
        }
        flowLayout?.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard galleryName != nil else {
            return 0
        }
        if let imageGalleryData = ImageGalleyGlobalDataSource.shared.getGalleryForName(name: galleryName!) {
            return imageGalleryData.images.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        if let imageCell = cell as? ImageGalleryCollectionViewCell {

            if let imageGalleryData = ImageGalleyGlobalDataSource.shared.getGalleryForName(name: galleryName!)?.images[indexPath.item] {
                let imageURL = imageGalleryData.imageURL
                let imageRatio = imageGalleryData.imageRatio
                if mapImageURLToUIImage[imageURL] != nil {
                    imageCell.spinner.isHidden = true
                    imageCell.imageView.image = mapImageURLToUIImage[imageURL]
                } else {
                    // fetch Image when load new gallery
                    imageCell.imageView.image = nil
                    imageCell.spinner.isHidden = false
                    imageCell.spinner.startAnimating()
                    imageCell.spinner.hidesWhenStopped = true
                    fetchImage(url: imageURL, position: indexPath.item, imageRatio: imageRatio, spinner: imageCell.spinner)
                }
            }
        }
        return cell
    }
    
    private func fetchImage(url: URL, position: Int, imageRatio: Double, spinner: UIActivityIndicatorView ){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let urlContents = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                spinner.stopAnimating()
                if let imageData = urlContents {
                    self?.mapImageURLToUIImage[url] = UIImage(data: imageData)
                    self?.collectionView.reloadData()
                } else {
                    self?.showAlertWhenImageUnableToFetch()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aspectRatio = ImageGalleyGlobalDataSource.shared.getGalleryForName(name: galleryName!)?.images[indexPath.item].imageRatio
        let imageHeight = currImagesWidth / aspectRatio!
        return CGSize(width: currImagesWidth, height: imageHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard galleryName != nil else {
            return
        }
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates({
                    ImageGalleyGlobalDataSource.shared.moveImageData(from: sourceIndexPath.item, to: destinationIndexPath.item, galleryName: galleryName!)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                // new item
            } else {
                let placeholderContext = coordinator.drop(
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
                
                // load image
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    // get aspect ratio
                    if let image = provider as? UIImage {
                        let imageWidth = image.size.width
                        let imageHeight = image.size.height
                        let imageRatio = Double(imageWidth) / Double(imageHeight)
                        self.lastImageRatio = imageRatio
                    }
                }
                
                // load image url
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    if let url = provider as? URL {
                        self.fetchImageAndUpdatePlaceholder(url: url.imageURL, placeholderContext: placeholderContext)
                    }
                }
            }
        }
    }
    
    private func fetchImageAndUpdatePlaceholder(url: URL, placeholderContext: UICollectionViewDropPlaceholderContext) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let urlContents = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let imageData = urlContents, let lastImageRatio = self?.lastImageRatio {
                    placeholderContext.commitInsertion(dataSourceUpdates: {insertionIndexPath in
                        if let galleryName = self?.galleryName {
                            ImageGalleyGlobalDataSource.shared.addImageToGallery(name: galleryName , imageData: ImageData.init(imageURL: url, imageRatio: lastImageRatio) , position: insertionIndexPath.item)
                            self?.mapImageURLToUIImage[url] = UIImage(data: imageData)
                            
                        }
                    })
                } else {
                    placeholderContext.deletePlaceholder()
                    self?.showAlertWhenImageUnableToFetch()
                }
            }
        }
    }
    
    private func showAlertWhenImageUnableToFetch(){
        let alertController = UIAlertController(title: "Sorry...", message:
            "Try another image", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let image = (imageGalleryView.cellForItem(at: indexPath) as? ImageGalleryCollectionViewCell)?.imageView.image {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            return [dragItem]
        } else {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if galleryName == nil {
            return false
        }
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        if isSelf {
            return session.canLoadObjects(ofClass: UIImage.self)
        } else {
            return session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSURL.self)
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageVC = segue.destination.content as? ImageScrollViewController {
            if let cell = sender as? ImageGalleryCollectionViewCell {
                imageVC.image = cell.imageView.image
            }
            
        }
    }
    
}

extension UIViewController {
    var content: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

