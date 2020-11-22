//
//  CreateColorExpC.swift
//  CustomView
//
//  Created by Ivan Murashov on 22.11.2020.
//

import UIKit

class CreateColorExpC: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
       
    private func customInit() {
        guard let view = Bundle.main.loadNibNamed("CreateColorExpC",
                owner: Any?.self,
                options: nil
        )?.first as? UIView else {
            return
        }
    }

    
    
    @IBAction func touchButtonInView(_ sender: Any) {
        
              let colors: [UIColor] = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.orange, UIColor.black, UIColor.purple, UIColor.blue]
              let randomColorIndex = arc4random() % 6
              self.backgroundColor = colors[Int(randomColorIndex)]
    }
    
}
