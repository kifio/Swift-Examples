//
//  LoginViewController.swift
//  TumblrClient
//
//  Created by Ivan Murashov on 30.09.2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginViewController: UIViewController {
    
    var oauthswift: OAuth1Swift?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func submit(_ sender: UIButton) {
        print("submit")
        let oauthswift = OAuth1Swift(
            consumerKey:    "",
            consumerSecret: "",
            requestTokenUrl: "https://www.tumblr.com/oauth/request_token",
            authorizeUrl:    "https://www.tumblr.com/oauth/authorize",
            accessTokenUrl:  "https://www.tumblr.com/oauth/access_token")
        
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        
        // authorize
        let handle = oauthswift.authorize(
            withCallbackURL: URL(string: "tumblr-client://oauth-callback/tumblr")!,
            success: { credential, response, parameters in
                print(credential.oauthToken)
                print(credential.oauthTokenSecret)
                print(parameters["user_id"] ?? "user id is empty")
                // Do your request
            },
            failure: { error in
                print(error.localizedDescription)
            })
    
    }

}
