//
//  YearViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 6/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit

class YearViewController: UITableViewController{
    
    var months:[String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", "Total"]
    
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true

    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthCell", for: indexPath) as! YearTableViewCell
        
        cell.monthLabel.text = months[indexPath.row]
        
        cell.monthAmountLabel.text = "0.00"
        
        return cell
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

