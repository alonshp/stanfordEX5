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
    
    private let galleriesMapFileNameOnDisk = "galleriesMap.json"
    
    private var galleriesMap = [String : ImageGalleryData]()
    
    var imageCache = NSCache<NSURL, UIImage>()
    
    // Initialization
    private override init() {
        // read galleries from disk
        super.init()
        openGalleriesMapData()
    }
    
    // MARK: read to disk and write to disk
    func encodeGalleriesMap() -> Data?{
        return try? JSONEncoder().encode(self.galleriesMap)
    }
    
    func decodeGalleriesMap(data: Data) -> [String : ImageGalleryData]? {
        return try? JSONDecoder().decode(Dictionary<String,ImageGalleryData>.self, from: data)
    }
    
    private func getURL(_ fileManager: FileManager, _ fileName: String) throws -> URL {
        return try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false).appendingPathComponent(fileName)
    }
    
    func writeGalleriesMapToDisk(data: Data, to fileName: String) {
        let fileManager = FileManager.default
        do {
            let url = try getURL(fileManager, fileName)
            try data.write(to: url)
        } catch {
            print(error)
        }
    }
    
    func readGalleriesMapDataFromDisk(from fileName: String) -> Data? {
        let fileManager = FileManager.default
        do {
            let url = try getURL(fileManager, fileName)
            return try Data(contentsOf: url)
        } catch {
            print(error)
        }
        return nil
    }
    
    func writeGalleriesMapToUserDefaults(data: Data, to key: String) {
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: key)
    }
    
    func readGalleriesMapDataFromUserDefaults(from key: String) -> Data? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key) as? Data
    }
    
    func saveGalleriesMapData() {
        if let encodedGalleriesMap = encodeGalleriesMap() {
            writeGalleriesMapToDisk(data: encodedGalleriesMap, to: galleriesMapFileNameOnDisk)
        }
    }
    
    func openGalleriesMapData() {
        if let data = readGalleriesMapDataFromDisk(from: galleriesMapFileNameOnDisk),
            let decodeGalleriesMap = decodeGalleriesMap(data: data){
            self.galleriesMap = decodeGalleriesMap
        }
    }
    
    // MARK: image gallery functions

    public func createGallery(name: String) {
        let newGallery = ImageGalleryData(images: [], name: name)
        galleriesMap[name] = newGallery
    }
    
    public func deleteGallery(name: String) {
        galleriesMap.removeValue(forKey: name)
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
    
    public func getArrayOfImageGalleryNames() -> [String] {
        var imageGalleryNames = [String]()
        for (galleryName, imageGalleryData) in galleriesMap {
            if !imageGalleryData.recentlyDeleted {
                imageGalleryNames.append(galleryName)
            }
        }
        return imageGalleryNames.sorted()
    }
    
    public func getArrayOfRecentlyDeletedImageGalleryNames() -> [String] {
        var RecentlyDeletedImageGalleryNames = [String]()
        for (galleryName, imageGalleryData) in galleriesMap {
            if imageGalleryData.recentlyDeleted {
                RecentlyDeletedImageGalleryNames.append(galleryName)
            }
        }
        return RecentlyDeletedImageGalleryNames.sorted()
    }
    
    public func updateRecentlyDeleted(ofGallery imageGalleryName: String, to deleted: Bool) {
        galleriesMap[imageGalleryName]?.recentlyDeleted = deleted
    }
    
    private func saveGalleriesToDisk() {
        
    }
}
