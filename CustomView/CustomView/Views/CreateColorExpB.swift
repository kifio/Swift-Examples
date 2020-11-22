//
//  CreateColorExpB.swift
//  CustomView
//
//  Created by Ivan Murashov on 22.11.2020.
//

import UIKit

class CreateColorExpB: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
//        customInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        customInit()
    }
       
    private func customInit() {
      
    }

    @IBAction func changeColorButtonTapped(_ sender: Any) {
           let colors: [UIColor] = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.orange, UIColor.black, UIColor.purple, UIColor.blue]
           let randomColorIndex = arc4random() % 6
           self.backgroundColor = colors[Int(randomColorIndex)]
       }

}
