//
//  ApiManager.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 19/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import UIKit

enum ApiRequestError: Error {
    case noInternetConnection
    case timeOutConnection
    case incorrectResponseFormat
    case incorrectUrlFormat
    case incorrectParameters
    case notFound // 404
    case badRequest //400
    case unknowErrorCode(errorCode: Int)
}

class ApiManager: NSObject {
    var session: URLSession = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func sendRequest(request: URLRequest, completion:@escaping (_ data: Data?, _ error: ApiRequestError?) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let response = response as? HTTPURLResponse {
                //TODO: handle proper error code
                if response.statusCode != 200 {
                    completion(nil, .incorrectUrlFormat)
                    
                } else {
                    //Hack.- For now check only success case
                    completion(data, nil)
                }
            } else {
                completion(nil, .incorrectUrlFormat)
            }
        })
        task.resume()
        return task
    }
    
    func getUrlRequest(apiFunction: String, httpMethod: String = "GET") -> URLRequest {
        var request = URLRequest(url: URL(string:apiFunction)!)
        request.httpMethod = httpMethod
        return request
    }
    
}

