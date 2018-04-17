//
//  ImageGalleryData.swift
//  Image Gallery
//
//  Created by Alon Shprung on 4/10/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation

struct ImageGalleryData: Codable {
    var images = [ImageData]()
    var recentlyDeleted = false
    var name:String
    
    init(images : [ImageData], name: String) {
        self.images = images
        self.name = name
    }
}

struct ImageData: Codable {
    var imageURL:URL
    var imageRatio:Double
    
    init(imageURL: URL, imageRatio: Double) {
        self.imageURL = imageURL
        self.imageRatio = imageRatio
    }
}
