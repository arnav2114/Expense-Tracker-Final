//
//  CurrencyViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 4/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit


class CurrencyController: UITableViewController{
    var currencies:[String] = ["¥ JPY","$ USD","$ SGD","£ GBP","€ EUR","₹ INR"]
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem?.title = "Back"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyTableViewCell
        
        cell.currencyLabel.text = currencies[indexPath.row]
        
        return cell
        
            }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        }
}



