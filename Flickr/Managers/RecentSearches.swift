//
//  RecentSearches.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 20/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import Foundation

class RecentSearches {
    static let recentSearchLimit = 5
    static let userDefaultKey = "RecentSearches"

    lazy var searches: [String] = {
        return UserManager.getRecentSearch() ?? []
    }()

    init() {
    }
    
    var  isRecentSearchesAvailable :Bool {
        return searches.count > 0
    }
    
    func add(_ key: String) {
        if let index = searches.index(where: {$0 == key}) {
            searches.remove(at: index)
        }
        searches.insert(key, at: searches.startIndex)
        if searches.count > RecentSearches.recentSearchLimit { _ = searches.popLast() }
        UserManager.saveRecentSearch(searches)
    }
}
