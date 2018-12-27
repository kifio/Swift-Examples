//
//  ViewController.swift
//  ConvexHull
//
//  Created by Ivan Murashov on 27/12/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var canvas: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvas = CanvasView(frame: view.frame)
        view.addSubview(canvas)
    }
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            canvas.buildPoints()
            canvas.setNeedsDisplay()
        }
    }
}

