//
//  Network.swift
//  TumblrClient
//
//  Created by Ivan Murashov on 10/09/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit
import Alamofire

class Network: NSObject {
    
    let decoder = JSONDecoder()
    let baseUrl = "https://api.tumblr.com/v2/tagged"
    var parameters: Parameters = ["api_key": "",
                                  "limit": 20,
                                  "before": 0]
    
    struct Response: Codable {
        let meta: Meta
        let response: [Post]
    }
    
    struct Meta: Codable {
        let status: Int
        let msg: String
    }
    
    struct Post: Codable {
        let type: String
        let post_url: String
        let photos: [Photo]?
    }
    
    struct Photo: Codable {
        let original_size: OriginalSize
    }
    
    struct OriginalSize: Codable {
        let url: String
    }
    
    func loadImage(stringUrl: String, completionHandler: @escaping (DataResponse<Data>) -> Void) {
        Alamofire.request(stringUrl).responseData(queue: DispatchQueue.main, completionHandler: completionHandler)
    }
    
    func search(tag: String?) {
        if tag != nil {
            parameters["tag"] = tag
            Alamofire.request(baseUrl, parameters: parameters).responseJSON { response in
                print("request url: \(response.request!)")
                self.handleResponse(self.decoder.decodeResponse(from: response))
            }
        } else {
            clearParameters()
        }
    }
    
    func loadMore() {
        
    }
    
    func handleResponse(_ result: Result<Response>) {
        if let serverResponse = result.value {
            for post in serverResponse.response {
                print(post.post_url)
            }
        }
    }
    
    func clearParameters() {
        parameters["tag"] = nil
        parameters["before"] = NSDate().timeIntervalSince1970 * 1000
    }
}

enum TumblrError: Error {
    case responseError
    case emptyResponse
    case decodingError
}

extension JSONDecoder {
    
    func decodeResponse<T: Decodable>(from response: DataResponse<Any>) -> Result<T> {
        guard response.error == nil else {
            print(response.error!)
            return .failure(TumblrError.responseError)
        }
        
        guard let responseData = response.data else {
            print("didn't get any data from API")
            return .failure(TumblrError.emptyResponse)
        }
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("\(error)")
            return .failure(TumblrError.decodingError)
        }
    }
}
