//
//  ViewController.swift
//  ImageDownloader
//
//  Created by Ivan Murashov on 08/09/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCachedImage()
    }
    
    private func loadImageFromInternet() {
        let url = URL(string: "https://hdqwalls.com/download/red-dead-redemption-2-62-1125x2436.jpg")
        let request = NSMutableURLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print(error!)
            } else {
                if data != nil {
                    self.createUIImage(data: data!)
                }
            }
        }
        task.resume()
    }
    
    private func createUIImage(data: Data) {
        if let img = UIImage(data: data) {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            if path.count > 0, let documentDirectory = path[0] as? String {
                self.saveImage(img: img, path: "\(documentDirectory)/rdr.jpg")
            }
            DispatchQueue.main.async {
                let imageView = UIImageView(image: img)
                self.view.addSubview(imageView)
            }
        }
    }
    
    private func saveImage(img: UIImage, path: String) {
        do {
            try UIImageJPEGRepresentation(img, 1)?.write(to: URL(fileURLWithPath: path))
        } catch {
            print("Can't save image!")
        }
    }
    
    private func loadCachedImage() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if path.count > 0, let documentDirectory = path[0] as? String {
            do {
                let img = UIImage(contentsOfFile: "\(documentDirectory)/rdr.jpg")
                let imageView = UIImageView(image: img)
                self.view.addSubview(imageView)
            } catch {
                print("Can't load cached image!")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

