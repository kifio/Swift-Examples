//
//  ViewController.swift
//  AdvancedSegues
//
//  Created by Ivan Murashov on 29/08/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var selectedRow = 0
    private let rowsCount = 4
    private let cellIdentifier = "Cell"
    private let segueIdentifier = "forth"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forth" {
            let secondViewController = segue.destination as! SecondViewController
            secondViewController.foo = selectedRow
        }
    }
}
