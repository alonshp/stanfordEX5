//
//  ImageGalleryTests.swift
//  ImageGalleryTests
//
//  Created by Alon Shprung on 4/15/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import XCTest
@testable import ImageGallery

class ImageGalleryTests: XCTestCase {
    
    let urlStr = "https://www.google.com"
    let galleryName = "untitled"
    let imageRatio = 13.5
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testEncodeAndDecodeImageData() {
        guard let imageUrl = URL(string: urlStr) else {
            XCTFail()
            return
        }
        let imageData = ImageData(imageURL: imageUrl, imageRatio: imageRatio)
        
        // encode
        let productJSON = try? JSONEncoder().encode(imageData)
        
        // decoede
        let decodedImageData = try? JSONDecoder().decode(ImageData.self, from: productJSON!)
        
        XCTAssertEqual(urlStr, imageData.imageURL.absoluteString)
        XCTAssertEqual(urlStr, decodedImageData?.imageURL.absoluteString)
        XCTAssertEqual(imageRatio, imageData.imageRatio)
        XCTAssertEqual(imageRatio, decodedImageData?.imageRatio)
    }
    
    func testEncodeAndDecodeImageGalleryData() {
        guard let imageUrl = URL(string: urlStr) else {
            XCTFail()
            return
        }
        let imageData = ImageData(imageURL: imageUrl, imageRatio: imageRatio)
        let imageGalleryData = ImageGalleryData(images: [imageData], name: galleryName)
        
        // encode
        let productJSON = try? JSONEncoder().encode(imageGalleryData)
        
        // decode
        let decodedImageGalleryData = try? JSONDecoder().decode(ImageGalleryData.self, from: productJSON!)
        
        XCTAssertEqual(urlStr, imageData.imageURL.absoluteString)
        XCTAssertEqual(urlStr, decodedImageGalleryData?.images[0].imageURL.absoluteString)
        XCTAssertEqual(imageRatio, imageData.imageRatio)
        XCTAssertEqual(imageRatio, decodedImageGalleryData?.images[0].imageRatio)
        XCTAssertEqual(galleryName, imageGalleryData.name)
        XCTAssertEqual(galleryName, decodedImageGalleryData?.name)
    }
    
    func testEncodeAndDecodeGalleriesMap(){
        guard let imageUrl = URL(string: urlStr) else {
            XCTFail()
            return
        }
        let imageData = ImageData(imageURL: imageUrl, imageRatio: imageRatio)
        let imageGalleryData = ImageGalleryData(images: [imageData], name: galleryName)
        
        var galleriesMap = [String : ImageGalleryData]()
        galleriesMap[galleryName] = imageGalleryData
        
        // encode
        let productJSON = try? JSONEncoder().encode(galleriesMap)
        
        // decode
        let decodedGalleriesMap = try? JSONDecoder().decode(Dictionary<String,ImageGalleryData>.self, from: productJSON!)
        
        XCTAssertEqual(urlStr, decodedGalleriesMap![galleryName]?.images[0].imageURL.absoluteString)
        XCTAssertEqual(imageRatio, decodedGalleriesMap![galleryName]?.images[0].imageRatio)
        XCTAssertEqual(galleryName, decodedGalleriesMap![galleryName]?.name)
    }
    
    func testReadAndWriteGalleriesMapToDisk() {
        let galleriesMapFileName = "galleriesMap.json"
        let otherGalleryName = "untitled2"
        let otherImageRatio = 16.8
        let otherUrlStr = "https://www.cnn.com"
        guard let imageUrl = URL(string: urlStr), let otherImageUrl = URL(string: otherUrlStr) else {
            XCTFail()
            return
        }
        let imageData = ImageData(imageURL: imageUrl, imageRatio: imageRatio)
        let otherImageData = ImageData(imageURL: otherImageUrl, imageRatio: otherImageRatio)
        
        let imageGalleryData = ImageGalleryData(images: [imageData], name: galleryName)
        let otherImageGalleryData = ImageGalleryData(images: [otherImageData, imageData], name: otherGalleryName)
        
        var galleriesMap = [String : ImageGalleryData]()
        galleriesMap[galleryName] = imageGalleryData
        galleriesMap[otherGalleryName] = otherImageGalleryData
        
        // write
        let productJSON = try? JSONEncoder().encode(galleriesMap)
        ImageGalleyGlobalDataSource.shared.writeGalleriesMapToDisk(data: productJSON!, to: galleriesMapFileName)

        // read
        let dataFromDisk = ImageGalleyGlobalDataSource.shared.readGalleriesMapDataFromDisk(from: galleriesMapFileName)
        XCTAssertNotNil(dataFromDisk)
        let decodedGalleriesMap = try? JSONDecoder().decode(Dictionary<String,ImageGalleryData>.self, from: dataFromDisk!)
        XCTAssertNotNil(decodedGalleriesMap)
        
        // test first gallery
        XCTAssertEqual(urlStr, decodedGalleriesMap![galleryName]?.images[0].imageURL.absoluteString)
        XCTAssertEqual(imageRatio, decodedGalleriesMap![galleryName]?.images[0].imageRatio)
        XCTAssertEqual(galleryName, decodedGalleriesMap![galleryName]?.name)
        
        // test second gallery
        XCTAssertEqual(otherUrlStr, decodedGalleriesMap![otherGalleryName]?.images[0].imageURL.absoluteString)
        XCTAssertEqual(urlStr, decodedGalleriesMap![otherGalleryName]?.images[1].imageURL.absoluteString)
        XCTAssertEqual(otherImageRatio, decodedGalleriesMap![otherGalleryName]?.images[0].imageRatio)
        XCTAssertEqual(imageRatio, decodedGalleriesMap![otherGalleryName]?.images[1].imageRatio)
        XCTAssertEqual(otherGalleryName, decodedGalleriesMap![otherGalleryName]?.name)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
