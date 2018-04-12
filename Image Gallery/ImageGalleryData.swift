//
//  ImageGalleryData.swift
//  Image Gallery
//
//  Created by Alon Shprung on 4/10/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation

struct ImageGalleryData {
    var images = [ImageData]()
    var name:String
    
    init(images : [ImageData], name: String) {
        self.images = images
        self.name = name
    }
}

struct ImageData {
    var imageURL:URL
    var imageRatio:Double
    
    init(imageURL: URL, imageRatio: Double) {
        self.imageURL = imageURL
        self.imageRatio = imageRatio
    }
}
