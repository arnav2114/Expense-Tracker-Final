//
//  MainScreenController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 5/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MainScreenController: UIViewController {
    
    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noExpenseLabel: UILabel!
    
    
    var cashImage: UIImage?
    var creditImage: UIImage?
    
    var expenses = [Expense]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        super.viewDidLoad()
        self.expenses = CoreDataHelper.retrieveExpenses()
        self.navigationController?.isNavigationBarHidden = true
        
        noExpenseLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noExpenseLabel.isHidden = true
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEE, MMMM d"
        let result = formatter.string(from: date)
        
        todayDate.text = result
        
        let formatter2 = DateFormatter()
        
        formatter2.dateFormat = "MMMM yyyy"
        let result2 = formatter2.string(from: date)
        
        self.navigationItem.title = result2
        self.navigationController?.isNavigationBarHidden = true

        self.expenses = CoreDataHelper.retrieveExpenses()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.expenses = CoreDataHelper.retrieveExpenses()
    }
    
    
    @IBAction func unwindToMainScreenController(_ segue: UIStoryboardSegue) {
        self.expenses = CoreDataHelper.retrieveExpenses()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "changeTransaction" {
                let indexPath = tableView.indexPathForSelectedRow!
                let expense = expenses[indexPath.row]
                
                let displayNewTransactionController = segue.destination as! NewTransactionController
                displayNewTransactionController.newExpenses = expense
                
                UserDefaults.standard.set(expense.category, forKey: "selectedCategory")
                
                UserDefaults.standard.set(expense.collection, forKey: "selectedCollection")
                
                UserDefaults.standard.set(expense.currency, forKey: "selectedCurrencyCode")
                
                UserDefaults.standard.set(expense.currencyName, forKey: "selectedCurrencyName")
                
                UserDefaults.standard.set(expense.currencySymbol, forKey: "selectedCurrencySymbol")
                
            }
        }
    }
    
}

extension MainScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expenses.count == 0 {
            noExpenseLabel.isHidden = false
        }
        return expenses.count
    }
    
    func convertToMoney(_ money:Double)->String{
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return(numberFormatter.string(for: money))!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        
        cell.layoutMargins = UIEdgeInsets.zero
        
        let row = indexPath.row
        
        let expense = expenses[row]
        
        for item in expenses {
            
            let date2 = Date()
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "MMM d, yyyy"
            let result3 = formatter3.string(from: date2)
            
            if item.modificationDate?.convertToString() != result3 {
                if let expenseSorter = expenses.index(of: item) {
                    expenses.remove(at: expenseSorter)
                }
            }
        }
        
        CoreDataHelper.save()
        
        var expenseAmountCalculating:Double = Double(expense.amount!)!
        var expenseAmountDisplayed:String = convertToMoney(expenseAmountCalculating)
        
        cell.expenseLabel.text = expense.name
        
        cell.expenseCategory.text = expense.category
        cell.expenseCollection.text = expense.collection
        
        var finalDisplayed:String = expense.currencySymbol! + " " + expenseAmountDisplayed
        cell.expenseAmount.text = finalDisplayed
        print(finalDisplayed)
        
        if expense.expense {
            cell.expenseAmount.textColor = UIColor.red
        }else if expense.income {
            cell.expenseAmount.textColor = UIColor(red:0.49, green:0.83, blue:0.13, alpha:1.0)
        }
        
        if expense.cash{
            cell.cashOrCredit.image = #imageLiteral(resourceName: "Cash Image")
            
        }
        else if expense.credit{
            cell.cashOrCredit.image = #imageLiteral(resourceName: "Credit Image")
            
        }
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 63.5;//Creating custom row height
    }
    
    
}

extension MainScreenController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print(indexPath.row)
            let expense = expenses[indexPath.row]
            CoreDataHelper.deleteExpense(expense: expense)
            expenses.remove(at: indexPath.row)
            expenses = CoreDataHelper.retrieveExpenses()
        }
    }
    
}



