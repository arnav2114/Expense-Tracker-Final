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
    
    var months:[String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December","Total"]
    var monthTotals:[Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    var monthPassed:String = ""
    
    var totalAmountDisplayed:String = ""
    
    var totalFinalAmount:Double = 0
    
    var monthExpenses = [Expense]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    @IBAction func moveBackToMonth(_sender:AnyObject){
        
        _ = navigationController?.popViewController(animated: true);
        
    }
    
    override func viewDidLoad() {
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.white
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        
        totalFinalAmount = 0
        
        for var i in 0..<months.count {
            totalFinalAmount += monthTotals[i]
            i += 1
        }
        
        for i in 0..<monthTotals.count {
            monthTotals[i] = UserDefaults.standard.double(forKey:"\(months[i])Total")
        }
        
//        if let total = UserDefaults.standard.string(forKey: "totalAmount") {
//            self.totalAmountDisplayed = total
//            tableView.reloadData()
//        }
        
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 63.5;//Creating custom row height
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthCell", for: indexPath) as! YearTableViewCell
        
        
        cell.monthLabel.text = months[indexPath.row]
        
        cell.monthAmountLabel.text = String(monthTotals[indexPath.row])
        
        cell.totalAmountLabel.text = String(totalFinalAmount)
        
        if indexPath.row == 12 {
            
            cell.totalAmountLabel.isHidden = false
            cell.monthAmountLabel.isHidden = true
        } else {
            cell.totalAmountLabel.isHidden = true
            cell.monthAmountLabel.isHidden = false
        }
        
        if Double(cell.monthAmountLabel.text!)! < 0 {
            cell.monthAmountLabel.textColor = UIColor.red
        }
            
        else if Double(cell.monthAmountLabel.text!)! >= 0 {
            cell.monthAmountLabel.textColor = UIColor.green
        }
        
        if Double(cell.totalAmountLabel.text!)! < 0 {
            cell.totalAmountLabel.textColor = UIColor.red
        }
            
        else if Double(cell.totalAmountLabel.text!)! >= 0 {
            cell.totalAmountLabel.textColor = UIColor.green
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
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


