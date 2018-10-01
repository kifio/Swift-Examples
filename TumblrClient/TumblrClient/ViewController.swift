//
//  ViewController.swift
//  TumblrClient
//
//  Created by Ivan Murashov on 10/09/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    static let CELL_ID = "cell"
    static let OAUTH_TOKEN = "oauthToken"
    
    let network = Network()
    let storage = Storage()
    
    static var apiKeys: Dictionary<String, String> {
        if let path = Bundle.main.path(forResource: "TumblrKeys", ofType: "plist") {
            return NSDictionary(contentsOfFile: path) as! Dictionary<String, String>
        } else {
            return Dictionary<String, String>()
        }
    }
    
    let oauthswift: OAuth1Swift = OAuth1Swift(
        consumerKey:    ViewController.apiKeys["ApiKey"] ?? "",
        consumerSecret: ViewController.apiKeys["ApiSecret"] ?? "",
        requestTokenUrl: "https://www.tumblr.com/oauth/request_token",
        authorizeUrl:    "https://www.tumblr.com/oauth/authorize",
        accessTokenUrl:  "https://www.tumblr.com/oauth/access_token")

    override func viewDidLoad() {
        super.viewDidLoad()
        if isUserAuthorized() {
            showTumblr()
        } else {
            authorize()
        }
    }
    
    private func isUserAuthorized() -> Bool {
        return UserDefaults.standard.object(forKey: ViewController.OAUTH_TOKEN) != nil
    }
    
    private func authorize() {
        self.oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        self.oauthswift.authorize(
            withCallbackURL: URL(string: "tumblr-client://oauth-callback/tumblr")!,
            success: { credential, response, parameters in
                print(credential.oauthTokenSecret)
                UserDefaults.standard.set(credential.oauthToken, forKey: ViewController.OAUTH_TOKEN)
                self.showTumblr()
            },
            failure: { error in
                print(error.localizedDescription)
            })
    }
    
    private func showTumblr() {
        addTableView()
        addSearchBar()
    }
    
    private func addTableView() {
        let imagesTableView = UITableView()
        imagesTableView.frame = CGRect(x: 0, y: 66, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        imagesTableView.dataSource = self
        imagesTableView.delegate = self
        imagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.CELL_ID)
        self.view.addSubview(imagesTableView)
    }
    
    private func addSearchBar() {
        let uiSearchBar = UISearchBar()
        uiSearchBar.frame =  CGRect(x: 0, y: 22, width: UIScreen.main.bounds.width, height: 44)
        uiSearchBar.delegate = self
        uiSearchBar.searchBarStyle = UISearchBarStyle.minimal
        self.view.addSubview(uiSearchBar)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        network.search(tag: searchBar.text)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storage.mock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.CELL_ID, for: indexPath as IndexPath)
        self.network.loadImage(stringUrl: self.storage.mock[indexPath.row], completionHandler: { response in
            if let image = UIImage(data: response.result.value!) {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleToFill
                imageView.frame = UIEdgeInsetsInsetRect(cell.contentView.frame, UIEdgeInsetsMake(16, 16, 16, 16))
                cell.contentView.addSubview(imageView)
            }
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width
    }
}
