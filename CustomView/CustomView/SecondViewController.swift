//
//  SecondViewController.swift
//  CustomView
//
//  Created by Ivan Murashov on 22.11.2020.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = Bundle.main.loadNibNamed("CreateColorExpB",
                owner: Any?.self,
                options: nil
        )?.first as? UIView else {
            return
        }
        
        self.view.addSubview(view)
        view.frame = CGRect(x: 0, y: 100,
                            width: self.view.frame.size.width,
                            height: view.frame.size.height
        )
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor.cyan
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
