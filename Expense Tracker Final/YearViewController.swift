//
//  YearViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 6/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class YearViewController: UITableViewController{
    
    var months:[String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", "Total"]
    var monthTotals:[Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    var monthPassed:String = ""
    
    var totalAmountDisplayed:String = ""
    
    var totalFinalAmount:Int = 0
    
    var monthExpenses = [Expense]() {
        didSet {
            tableView.reloadData()
        }
    }

    
    @IBAction func moveBackToMonth(_sender:AnyObject){
    
        _ = navigationController?.popViewController(animated: true);

     }
    
    override func viewDidLoad() {

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        
        for i in 0..<monthTotals.count {
            monthTotals[i] = UserDefaults.standard.integer(forKey:"\(months[i])Total")
        }
        
        if let total = UserDefaults.standard.string(forKey: "totalAmount") {
            self.totalAmountDisplayed = total
            tableView.reloadData()
        }
        

        
        /*for month in months{
            totalFinalAmount = Int(totalAmountDisplayed)!.reduce(0) { $0 + $1 }
        }
        }*/
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthCell", for: indexPath) as! YearTableViewCell
        
        cell.monthLabel.text = months[indexPath.row]
            
        cell.monthAmountLabel.text = String(monthTotals[indexPath.row])
        
        /*if Int(cell.monthLabel.text!)! < 0 {
            cell.monthLabel.textColor = UIColor.red
        }*/
        
        cell.totalAmountLabel.text = String(totalFinalAmount)
        
        if indexPath.row == 12 {
            
            cell.totalAmountLabel.isHidden = false
            cell.monthAmountLabel.isHidden = true
        } else {
            cell.totalAmountLabel.isHidden = true
            cell.monthAmountLabel.isHidden = false
        }
        
        
        return cell
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let monthlyDisplayController = segue.destination as! MonthlyDisplayViewController
        monthlyDisplayController.navigationItem.title = monthPassed
        monthlyDisplayController.month = monthPassed
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        monthPassed = months[indexPath.row]
        
        performSegue(withIdentifier: "displayMonth", sender: self)
        
    }
}


