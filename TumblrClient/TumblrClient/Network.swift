//
//  Network.swift
//  TumblrClient
//
//  Created by Ivan Murashov on 10/09/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit
import OAuthSwift
import SafariServices

class Network: NSObject {
    
    static let OAUTH_CREDENTIAL = "oauthCredential"
    static var apiKeys: Dictionary<String, String> {
        if let path = Bundle.main.path(forResource: "TumblrKeys", ofType: "plist") {
            return NSDictionary(contentsOfFile: path) as! Dictionary<String, String>
        } else {
            return Dictionary<String, String>()
        }
    }
    
    let oauthswift: OAuth1Swift = OAuth1Swift(
        consumerKey:    Network.apiKeys["ApiKey"] ?? "",
        consumerSecret: Network.apiKeys["ApiSecret"] ?? "",
        requestTokenUrl: "https://www.tumblr.com/oauth/request_token",
        authorizeUrl:    "https://www.tumblr.com/oauth/authorize",
        accessTokenUrl:  "https://www.tumblr.com/oauth/access_token")
    let decoder = JSONDecoder()
    var url: URLComponents = URLComponents(string: "https://api.tumblr.com/v2/tagged") ?? URLComponents()
    var oauthSwiftClient: OAuthSwiftClient?
    var before = 0
    var tag: String? = nil
    
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
    
    func authorize(viewController: ViewController) {
        self.oauthswift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: oauthswift)
        self.oauthswift.authorize(
            withCallbackURL: URL(string: "tumblr-client://oauth-callback/tumblr")!,
            success: { credential, response, parameters in
                print(credential.oauthTokenSecret)
                do {
                    UserDefaults.standard.set(try PropertyListEncoder().encode(credential), forKey: Network.OAUTH_CREDENTIAL)
                } catch let err {
                    print(err)
                }
                self.createClient()
                viewController.showTumblr()
        },
            failure: { error in
                print(error.localizedDescription)
        })
    }
    
    func createClient() {
        if let credential = getCredential() {
            oauthSwiftClient = OAuthSwiftClient(credential: credential)
        }
    }
    
    func getCredential() -> OAuthSwiftCredential? {
        if let data = UserDefaults.standard.value(forKey: Network.OAUTH_CREDENTIAL) as? Data {
            do {
            	return try PropertyListDecoder().decode(OAuthSwiftCredential.self, from: data)
            } catch let err {
                print(err)
                return nil
            }
        } else {
            return nil
        }
    }
    
    func logout(viewController: ViewController) {
        var controller = SFSafariViewController(url: URL(string: "https://www.tumblr.com/logout")!)
        viewController.present(controller, animated: true, completion: nil)
        UserDefaults.standard.removeObject(forKey: Network.OAUTH_CREDENTIAL)
    }
  
    func search(tag: String?) {
        if tag != nil {
            self.tag = tag
            self.before = Int(NSDate().timeIntervalSince1970 * 1000)
            loadMore()
        } else {
            clearParameters()
        }
    }
    
    func loadMore() {
        url.queryItems = buildQueryItems()
        print(url.url!.absoluteString)
        oauthswift.client.get(url.url!.absoluteString, success: { response in
            self.handleResponse(data: response.data)
        }, failure: { error in
            print(error)
        })
    }
    
    func handleResponse(data: Data) {
        do {
            let serverResponse = try JSONDecoder().decode(Response.self, from: data)
            for post in serverResponse.response {
                print(post.post_url)
            }
        } catch let err {
            print(err)
        }
    }
    
    func buildQueryItems() -> [URLQueryItem] {
        return [URLQueryItem(name: "limit", value: "20"),
                URLQueryItem(name: "before", value: "\(before)"),
                URLQueryItem(name: "tag", value: tag!)]
    }
    
    func clearParameters() {
        tag = nil
    }
}

enum TumblrError: Error {
    case responseError
    case emptyResponse
    case decodingError
}
