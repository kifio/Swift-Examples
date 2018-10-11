//
//  DetailViewController.swift
//  Blog Reader
//
//  Created by Ivan Murashov on 11/10/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let blogView = self.webView {
                blogView.loadHTMLString(
                    detail.value(forKey: "content") as! String,
                                   baseURL: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

