//
//  FlickrTestCases.swift
//  FlickrTests
//
//  Created by Imayaselvan Ramakrishnan on 20/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import XCTest
@testable import Flickr
class FlickrTestCases: XCTestCase {

    func testImageUrlwithNil() {
        let model = Photo(photoId: "1", farmId: 1, serverId: "1", secretKey: "2")
        XCTAssertEqual(model.imageUrl(), URL(string: "https://farm1.staticflickr.com/1/1_2_m.jpg"))
    }

    //Recent Searches, User Manager
    func testSaveRecentSearch() {
        UserManager.saveRecentSearch(["test1"])
        XCTAssertEqual(UserDefaults.standard.array(forKey: "RecentSearches") as! [String] , ["test1"])
    }
    
    func testGetRecentSearchesNilFirstTime() {
        for key in Array(UserDefaults.standard.dictionaryRepresentation().keys) {
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        XCTAssertNil(UserManager.getRecentSearch())
    }
    
    func testGetRecentSearches() {
        UserDefaults.standard.set(["test"], forKey: "RecentSearches")
        let recentSearches = RecentSearches()
        
        XCTAssertEqual(recentSearches.searches.count , 1)
        XCTAssertEqual(recentSearches.searches.first , "test")
        XCTAssertEqual(recentSearches.isRecentSearchesAvailable , true)
    }
    
    func testEmptyRecentSearch() {
        UserDefaults.standard.set([], forKey: "RecentSearches")
        let recentSearches = RecentSearches()
        
        XCTAssertEqual(recentSearches.searches.count , 0)
        XCTAssertEqual(recentSearches.isRecentSearchesAvailable , false)
        
    }
    
    func testRecentSearchLimit() {
        for key in Array(UserDefaults.standard.dictionaryRepresentation().keys) {
            UserDefaults.standard.removeObject(forKey: key)
        }

        let searches = ["1","2","3","4","5"]
        let recentSearches = RecentSearches()
        recentSearches.searches = searches
        recentSearches.add("6")
        XCTAssertEqual(recentSearches.searches.count , 5)
        print(recentSearches.searches)
        XCTAssertEqual(recentSearches.searches.first , "6")

    }
    
    //Api Manager
    func testUrlRequest() {
        let manager = ApiManager.init()
        let request = manager.getUrlRequest(apiFunction: "https://www.google.com", httpMethod: "GET")
        XCTAssertEqual(request.url!, URL(string: "https://www.google.com"))
    }


    

}
