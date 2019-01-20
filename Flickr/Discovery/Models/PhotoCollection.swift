//
//  PhotoCollection.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 19/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import UIKit

protocol PhotoCollectionDelegate: class {
    func fetchCompleted()
}

class PhotoCollection: NSObject {

    var models = [Photo]()
    let searchText: String
    var totalCount: Int = 0
    var page: Int = 1

    let listingManager = PhotoListingsService()
    weak var delegate: PhotoCollectionDelegate?
    fileprivate var isLoading = false
    
    init(searchText: String, model :[Photo], total:Int) {
        self.searchText = searchText
        self.models = model
        self.totalCount = total
    }
   
    func loadMore() {
        guard page  < totalCount else {
            return
        }
        
        guard isLoading == false else {
            return
        }

        page = page + 1
        isLoading = true
        
        listingManager.getPhotosList(key: self.searchText, page: page) { (collection, error) in
            //TODO : Proper Error Handling
            if let error = error {
                print(" error: \(error.localizedDescription)")
                return
            }
            guard let collection = collection  else { return }
            DispatchQueue.main.async {
                self.append(collection.photos.photos)
            }
            self.isLoading = false
        }
    }
}


extension PhotoCollection {
    
    var count: Int {
        return models.count
    }
    
    func at(_ index: Int) -> Photo {
        return models[index]
    }
    
    func append(_ models: [Photo]) {
        self.models.append(contentsOf: models)
        delegate?.fetchCompleted()
    }
}
