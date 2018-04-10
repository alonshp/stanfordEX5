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
    
    var galleries = [ImageGalleryData]()
    
    // Initialization
    private override init() {
        // read galleries from disk
    }
    
    public func createGallery(name: String) {
        //TODO
    }
    
    public func addImageToGallery(imageUrl: URL, galleryName:String, imageRatio: Double) {
        //TODO
    }
    
    public func changeGalleryName(from: String, to: String) {
        //TODO
    }
    
    public func getGalleryForName(name: String) -> ImageGalleryData? {
        //TODO
        return nil //temp
    }
    
    private func saveGalleriesToDisk() {
        
    }
}
