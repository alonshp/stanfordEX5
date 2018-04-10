//
//  ImageGalleryData.swift
//  Image Gallery
//
//  Created by Alon Shprung on 4/10/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation

struct ImageGalleryData {
    var imageURLs = [URL]()
    var imageRatios = [Double]()
    var name:String
    
    init(imageURLs : [URL], imageRatios : [Double], name: String) {
        self.imageURLs = imageURLs
        self.imageRatios = imageRatios
        self.name = name
    }
}
