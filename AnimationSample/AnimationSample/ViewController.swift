//
//  ViewController.swift
//  AnimationSample
//
//  Created by Ivan Murashov on 28/08/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let max = 149
    private let min = 0
    private var counter = 0
    private var images: [Int: UIImage] = [:]
    private var timer: Timer? = nil
    
    @IBOutlet weak var img: UIImageView!
    
    @IBAction func play(_ sender: Any) {
        if (timer == nil) {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.setFrame), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @IBAction func fade(_ sender: Any) {
        
        self.img.alpha = 0
        
        UIView.animate(withDuration: 1, animations: {
            self.img.alpha = 1
        })
    }
    
    @objc private func setFrame() {
        
        if (counter > max) {
            counter = min
        }
        
        print("frame_\(String(format: "%03d", counter))_delay-0.1s.gif")
        
        if (images[counter] == nil) {
            images[counter] = UIImage(named: "frame_\(String(format: "%03d", counter))_delay-0.1s.gif")
        }
        
        img.image = images[counter]
        counter += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

