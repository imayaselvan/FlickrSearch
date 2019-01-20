//
//  PhotoListService.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 19/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import Foundation

class PhotoListingsService: ApiManager {
    
    func getPhotosList(key:String, page:Int, completion: @escaping (_ posts: PhotosContainer?, _ error: ApiRequestError?) -> Void) {
        let request = getUrlRequest(apiFunction:"\(Endpoints.Movies.fetch.url)text=\(key.encodedString())&page=\(page)", httpMethod: "GET")
        _ = sendRequest(request: request, completion: { (data, error) in
            if let error = error {
                completion( nil, error)
            }else {
                if let photos = try? JSONDecoder().decode(PhotosContainer.self, from: data!) {
                    completion( photos , nil)
                }
                else {
                    completion( nil, .incorrectResponseFormat)
                }
            }
        })
    }
}

extension String {
    func encodedString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    }
}
