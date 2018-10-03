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
    
    let network = Network()
    let storage = Storage()

    override func viewDidLoad() {
        super.viewDidLoad()
        if network.getCredential() != nil {
            network.createClient()
            showTumblr()
        } else {
            network.authorize(viewController: self)
        }
    }
    
    func showTumblr() {
        addTableView()
        addSearchBar()
        addLogoutButton()
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
        uiSearchBar.frame =  CGRect(x: 0, y: 22, width: UIScreen.main.bounds.width - 64, height: 44)
        uiSearchBar.delegate = self
        uiSearchBar.searchBarStyle = UISearchBarStyle.minimal
        self.view.addSubview(uiSearchBar)
    }
    
    private func addLogoutButton() {
        let logoutButton = UIButton()
        logoutButton.frame = CGRect(x: UIScreen.main.bounds.width - 66, y: 22, width: 64, height: 44)
        logoutButton.setTitle("Logout", for: UIControlState.normal)
        logoutButton.setTitleColor(self.view.tintColor, for: UIControlState.normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.view.addSubview(logoutButton)
    }
    
    @objc func logout() {
        network.logout(viewController: self)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        network.search(tag: searchBar.text)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storage.mock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.CELL_ID, for: indexPath as IndexPath)
//        self.network.loadImage(stringUrl: self.storage.mock[indexPath.row], completionHandler: { response in
//            if let image = UIImage(data: response.result.value!) {
//                let imageView = UIImageView(image: image)
//                imageView.contentMode = .scaleToFill
//                imageView.frame = UIEdgeInsetsInsetRect(cell.contentView.frame, UIEdgeInsetsMake(16, 16, 16, 16))
//                cell.contentView.addSubview(imageView)
//            }
//        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width
    }
}
