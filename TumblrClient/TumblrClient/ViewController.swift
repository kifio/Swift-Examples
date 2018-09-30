//
//  ViewController.swift
//  TumblrClient
//
//  Created by Ivan Murashov on 10/09/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let network = Network()
    let storage = Storage()
    let cellId = "cell"

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        network.search(tag: searchBar.text)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storage.mock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        addSearchBar()
    }
    
    private func addSearchBar() {
        let uiSearchBar = UISearchBar()
        uiSearchBar.frame =  CGRect(x: 0, y: 22, width: UIScreen.main.bounds.width, height: 44)
        uiSearchBar.delegate = self
        uiSearchBar.searchBarStyle = UISearchBarStyle.minimal
        self.view.addSubview(uiSearchBar)
    }
    
    private func addTableView() {
        let imagesTableView = UITableView()
        imagesTableView.frame = CGRect(x: 0, y: 66, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        imagesTableView.dataSource = self
        imagesTableView.delegate = self
        imagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.view.addSubview(imagesTableView)
    }
}

