//
//  UserManager.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 20/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import Foundation

class UserManager {
    class func saveRecentSearch(_ suggestions:[String]) {
        UserDefaults.standard.set(suggestions, forKey: RecentSearches.userDefaultKey)
    }
    
    class func getRecentSearch() -> [String]? {
        guard let storedSuggestionsArray = UserDefaults.standard.object(forKey: RecentSearches.userDefaultKey) as? [String] else { return nil }
        return  storedSuggestionsArray
    }
}
