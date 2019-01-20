//
//  ImageModel.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 17/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let photoId: String
    let farmId: Int
    let serverId: String
    let secretKey: String
    
    enum CodingKeys: String, CodingKey {
        case photoId   = "id"
        case farmId    = "farm"
        case secretKey = "secret"
        case serverId  = "server"
    }
    
    func imageUrl() -> URL! {
        return URL(string: "https://farm\(farmId).staticflickr.com/\(serverId)/\(photoId)_\(secretKey)_m.jpg")!
    }

}

struct PhotosArray: Codable {
    let currentPage: Int
    let totalPages: Int
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case currentPage     = "page"
        case totalPages      = "pages"
        case photos          = "photo"
    }
}

struct PhotosContainer: Codable {
    let photos: PhotosArray
    enum CodingKeys: String, CodingKey {
        case photos    
    }
}
