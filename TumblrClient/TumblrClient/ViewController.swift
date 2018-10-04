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
    var photos = [String]()
    
    var imagesTableView: UITableView? = nil
    var uiSearchBar: UISearchBar? = nil
    
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
        imagesTableView = UITableView()
        imagesTableView!.frame = CGRect(x: 0, y: 66, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        imagesTableView!.dataSource = self
        imagesTableView!.delegate = self
        imagesTableView!.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.CELL_ID)
        self.view.addSubview(imagesTableView!)
    }
    
    private func addSearchBar() {
        uiSearchBar = UISearchBar()
        uiSearchBar!.frame =  CGRect(x: 0, y: 22, width: UIScreen.main.bounds.width - 64, height: 44)
        uiSearchBar!.delegate = self
        uiSearchBar!.searchBarStyle = UISearchBarStyle.minimal
        self.view.addSubview(uiSearchBar!)
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
        search()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.CELL_ID, for: indexPath as IndexPath)
        self.network.loadImage(stringUrl: photos[indexPath.row], completionHandler: { response in
            if let image = UIImage(data: response) {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            search()
        }
    }
    
    func search() {
        network.search(tag: uiSearchBar?.text, completion: { urls in
            self.photos.append(contentsOf: urls)
            self.imagesTableView!.reloadData()
        }, failure: { msg in
//            print(msg)
        })
    }
}
