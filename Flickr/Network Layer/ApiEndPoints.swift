//
//  ApiEndPoints.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 19/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import Foundation

struct API {
    static let baseUrl = "https://api.flickr.com/"
}

struct Configuration {
    static let flickrKey      = "f2ddfcba0e5f88c2568d96dcccd09602"
    static let listingPerPage =  50
}

protocol ApiEndPonits {
    var path: String { get }
    var url: String { get }
}

enum Endpoints {
    enum Movies: ApiEndPonits {
        case fetch
        public var path: String {
            switch self {
            case .fetch: return "services/rest/?method=flickr.photos.search&api_key=\(Configuration.flickrKey)&format=json&nojsoncallback=1&safe_search=1&per_page=\(Configuration.listingPerPage)&"
            }
        }
        public var url: String {
            switch self {
            case .fetch: return "\(API.baseUrl)\(path)"
            }
        }
    }
}
