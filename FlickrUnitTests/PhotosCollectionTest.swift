//
//  PhotosCollectionTest.swift
//  FlickrTests
//
//  Created by Imayaselvan Ramakrishnan on 20/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import XCTest
@testable import Flickr

class PhotosCollectionTest: XCTestCase {

    func testPhotoCollection() {
        let photo1 = Photo.init(photoId: "1", farmId: 1, serverId: "1", secretKey: "1")

        let collection = PhotoCollection(searchText: "test", model: [photo1] , total: 3)
        
        XCTAssertEqual(collection.count, 1)
        XCTAssertEqual(collection.at(0).farmId, photo1.farmId)
        
        let photo2 = Photo.init(photoId: "1", farmId: 2, serverId: "1", secretKey: "1")
        collection.append([photo2])
        
        XCTAssertEqual(collection.count, 2)
        XCTAssertEqual(collection.at(1).farmId, photo2.farmId)
        
    }
    
    func testLoadMore() {
        let photo1 = Photo.init(photoId: "1", farmId: 1, serverId: "1", secretKey: "1")
        let collection = PhotoCollection(searchText: "test", model: [photo1] , total: 2)
        collection.loadMore()
        XCTAssertEqual(collection.page, 2)
        XCTAssertEqual(collection.searchText, "test")

        

    }
    
}
