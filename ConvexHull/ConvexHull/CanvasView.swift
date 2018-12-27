//
//  CanvasView.swift
//  ConvexHull
//
//  Created by Ivan Murashov on 27/12/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    let padding = 32
    let size = CGSize(width: 2, height: 2)
    let maxDots = 100
    
    var points: [CGPoint?]
    var paths: [UIBezierPath?]
    
    override init(frame: CGRect) {
        self.points = [CGPoint?](repeating: nil, count: maxDots)
        self.paths = [UIBezierPath?](repeating: nil, count: maxDots)
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        buildPoints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.points = [CGPoint?](repeating: nil, count: maxDots)
        self.paths = [UIBezierPath?](repeating: nil, count: maxDots)
        super.init(coder: aDecoder)
    }
    
    func buildPoints() {
        let maxX = Int(Int(frame.width) - padding)
        let maxY = Int(Int(frame.height) - padding)
        points.removeAll()
        for _ in 0...maxDots {
            points.append(CGPoint(x: Int.random(in: padding...maxX),
                                  y: Int.random(in: padding...maxY)))
        }
    }
    
    func drawPoints() {
        print("drawPoints")
        UIColor.black.set()
        for i in 0..<maxDots {
            paths[i]?.removeAllPoints()
            paths[i] = UIBezierPath(ovalIn: CGRect(origin: points[i]!, size: size))
            paths[i]!.fill()
        }
    }

    override func draw(_ rect: CGRect) {
        self.drawPoints()
    }
}
