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
    var currencies:[String] = ["JPY ¥","USD $","SGD $","GBP £","EUR €","INR ₹"]
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem?.title = "Back"
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyTableViewCell
        
        let row = indexPath.row
        let currency = currencies[row]
        cell.currencyLabel.text = currency
        
        return cell
        
            }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        UserDefaults.standard.set(currencies[indexPath.row], forKey: "selectedCurrency")
        performSegue(withIdentifier: "unwindToNewTransactionViewController", sender: self)
        
    }

}



