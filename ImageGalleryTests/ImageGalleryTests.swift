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
        let imageData = ImageData(imageURL: imageUrl, imageRatio: 13.5)
        
        // encode
        let productJSON = try? JSONEncoder().encode(imageData)
        
        // decoede
        let decodedImageData = try? JSONDecoder().decode(ImageData.self, from: productJSON!)
        
        XCTAssertEqual(urlStr, imageData.imageURL.absoluteString)
        XCTAssertEqual(urlStr, decodedImageData?.imageURL.absoluteString)
        XCTAssertEqual(13.5, imageData.imageRatio)
        XCTAssertEqual(13.5, decodedImageData?.imageRatio)
    }
    
    func testEncodeAndDecodeImageGalleryData() {
        guard let imageUrl = URL(string: urlStr) else {
            XCTFail()
            return
        }
        let imageData = ImageData(imageURL: imageUrl, imageRatio: 13.5)
        let imageGalleryData = ImageGalleryData(images: [imageData], name: "untitled")
        
        // encode
        let productJSON = try? JSONEncoder().encode(imageGalleryData)
        
        // decode
        let decodedImageGalleryData = try? JSONDecoder().decode(ImageGalleryData.self, from: productJSON!)
        
        XCTAssertEqual(urlStr, imageData.imageURL.absoluteString)
        XCTAssertEqual(urlStr, decodedImageGalleryData?.images[0].imageURL.absoluteString)
        XCTAssertEqual(13.5, imageData.imageRatio)
        XCTAssertEqual(13.5, decodedImageGalleryData?.images[0].imageRatio)
        XCTAssertEqual("untitled", imageGalleryData.name)
        XCTAssertEqual("untitled", decodedImageGalleryData?.name)
    }
    
    func testEncodeAndDecodegalleriesMap(){
        guard let imageUrl = URL(string: urlStr) else {
            XCTFail()
            return
        }
        let imageData = ImageData(imageURL: imageUrl, imageRatio: 13.5)
        let imageGalleryData = ImageGalleryData(images: [imageData], name: "untitled")
        
        var galleriesMap = [String : ImageGalleryData]()
        galleriesMap["untitled"] = imageGalleryData
        
        // encode
        let productJSON = try? JSONEncoder().encode(galleriesMap)
        
        // decode
        let decodedgalleriesMap = try? JSONDecoder().decode(Dictionary<String,ImageGalleryData>.self, from: productJSON!)
        
        XCTAssertEqual(urlStr, decodedgalleriesMap!["untitled"]?.images[0].imageURL.absoluteString)
        XCTAssertEqual(13.5, decodedgalleriesMap!["untitled"]?.images[0].imageRatio)
        XCTAssertEqual("untitled", decodedgalleriesMap!["untitled"]?.name)

        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
