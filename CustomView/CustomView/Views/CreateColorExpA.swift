//
//  CreateColorExpA.swift
//  CustomView
//
//  Created by Ivan Murashov on 22.11.2020.
//

import UIKit

class CreateColorExpA: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
       
    private func customInit() {
        let nib = UINib(nibName: "CreateColorExpA", bundle: nil)
        guard let view = nib.instantiate(
                withOwner: self,
                options: nil
        ).first as? UIView else {
            return
        }
        
        view.backgroundColor = UIColor.clear
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = UIColor.cyan
    }

    @IBAction func changeColorButtonTapped(_ sender: Any) {
           let colors: [UIColor] = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.orange, UIColor.black, UIColor.purple, UIColor.blue]
           let randomColorIndex = arc4random() % 6
           self.backgroundColor = colors[Int(randomColorIndex)]
       }
    
}
