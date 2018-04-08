//
//  ImageGalleryTableViewController.swift
//  Image Gallery
//
//  Created by Alon Shprung on 4/1/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapToEdit(_:)))
        tapGesture.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var imageGalleryDocuments = ["template1", "template2"]
    var recentlyDeletedDocuments = ["deleted1", "deleted2"]

    @objc func doubleTapToEdit(_ sender: UITapGestureRecognizer){
        if sender.state == UIGestureRecognizerState.ended {
            let tapLocation = sender.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.tableView.cellForRow(at: tapIndexPath) as? EditTableViewCell {
                    tappedCell.textField.isEnabled = true
                }
            }
        }
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? imageGalleryDocuments.count : recentlyDeletedDocuments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        if let editCell = cell as? EditTableViewCell {
            if indexPath.section == 0 {
                editCell.textField.isEnabled = false
                editCell.textField.text = imageGalleryDocuments[indexPath.row]
                editCell.resignationHandler = {
                    if let text = editCell.textField.text {
                        self.imageGalleryDocuments[indexPath.row] = text
                        tableView.reloadData()
                    }
                }
            } else {
                editCell.textField.isEnabled = false
                editCell.textField.text = recentlyDeletedDocuments[indexPath.row]
                editCell.resignationHandler = {
                    if let text = editCell.textField.text {
                        self.recentlyDeletedDocuments[indexPath.row] = text
                        tableView.reloadData()
                    }
                }
            }

        }

        return cell
    }
    
    @IBAction func newImageGallery(_ sender: UIBarButtonItem) {
        imageGalleryDocuments += ["Untitled".madeUnique(withRespectTo: imageGalleryDocuments + recentlyDeletedDocuments)]
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "" : "Recently Deleted"
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 1 {
            return true
        } else {
            return true
        }
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == 1 {
                lastSeguedToImageGalleryViewController.removeValue(forKey: recentlyDeletedDocuments[indexPath.row])
                recentlyDeletedDocuments.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                let deletedImageGallery = imageGalleryDocuments[indexPath.row]
                imageGalleryDocuments.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                recentlyDeletedDocuments += [deletedImageGallery]
                tableView.reloadData()
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // swipe to the other direction for undelete
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let contextualAction = UIContextualAction.init(style: .normal, title: "Undelete", handler: {_,_,_ in
                let undeletedImageGallery = self.recentlyDeletedDocuments[indexPath.row]
                self.recentlyDeletedDocuments.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.imageGalleryDocuments += [undeletedImageGallery]
                tableView.reloadData()
            })
            return UISwipeActionsConfiguration.init(actions: [contextualAction])
        }
        return nil
    }
    
    private var splitViewDetailViewController: ViewController? {
        return splitViewController?.viewControllers.last as? ViewController
    }
    
    private var lastSeguedToImageGalleryViewController = [String : ViewController]()
    private var lastRowSelected: Int?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let lastImageGalleryController = lastSeguedToImageGalleryViewController[imageGalleryDocuments[indexPath.row]] {
                if let splitViewController = splitViewDetailViewController {
                    if let lastRowSelected = lastRowSelected {
                        lastSeguedToImageGalleryViewController[imageGalleryDocuments[lastRowSelected]] = splitViewController
                    }
                    splitViewController.reloadData(
                        images: lastImageGalleryController.images,
                        imageRatios: lastImageGalleryController.imageRatios)
                } else {
                    navigationController?.pushViewController(lastImageGalleryController, animated: true)
                }
            } else {
                performSegue(withIdentifier: "Choose Image Gallery", sender: tableView.cellForRow(at: indexPath))
            }
            lastRowSelected = indexPath.row
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageGalleryController = segue.destination as? ViewController {
            if let cell = sender as? EditTableViewCell {
                imageGalleryController.title = cell.textField.text!
                lastSeguedToImageGalleryViewController[cell.textField.text!] = imageGalleryController
            }
        }
    }
}
