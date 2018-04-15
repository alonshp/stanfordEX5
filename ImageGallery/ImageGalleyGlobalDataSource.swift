//
//  ImageGalleyGlobalDataSource.swift
//  Image Gallery
//
//  Created by Alon Shprung on 4/10/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class ImageGalleyGlobalDataSource: NSObject {
    
    static let shared = ImageGalleyGlobalDataSource()
    
    private var galleriesMap = [String : ImageGalleryData]()
    
    // Initialization
    private override init() {
        // read galleries from disk
    }
    
    public func createGallery(name: String) {
        let newGallery = ImageGalleryData(images: [], name: name)
        galleriesMap[name] = newGallery
    }
    
    public func addImageToGallery(name:String, imageData: ImageData, position: Int) {
        galleriesMap[name]?.images.insert(imageData, at: position)
    }
    
    public func changeGalleryName(from: String, to: String) {
        if let galleryData = galleriesMap[from]?.images {
            galleriesMap[to] = ImageGalleryData(images: galleryData, name: to)
            galleriesMap.removeValue(forKey: from)
            galleriesMap[from]?.name = to
        }
    }
    
    public func getGalleryForName(name: String) -> ImageGalleryData? {
        if let imageGallery = galleriesMap[name] {
            return imageGallery
        } else {
            return nil
        }
    }
    
    public func moveImageData(from: Int, to: Int, galleryName: String){
        if let imageData = galleriesMap[galleryName]?.images[from] {
            galleriesMap[galleryName]?.images.remove(at: from)
            galleriesMap[galleryName]?.images.insert(imageData, at: to)
        }
        
    }
    
    private func saveGalleriesToDisk() {
        
    }
}
