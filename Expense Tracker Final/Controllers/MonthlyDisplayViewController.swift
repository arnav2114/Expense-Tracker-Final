//
//  MonthlyExpenseViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 9/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

//
//  CollectionDisplayViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 8/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MonthlyDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var month:String?
    var sum:Double = 0
    
    @IBOutlet weak var tableView:UITableView!
    
    var monthlyExpenses = [Expense]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var noExpenseLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.backItem?.title = "Back"
        
        noExpenseLabel.isHidden = true
        
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()

        
    }
    
    func convertToMoney(_ money:Double)->String{
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return(numberFormatter.string(for: money))!
    }

    
    override func viewWillAppear(_ animated: Bool) {
        noExpenseLabel.isHidden = true
        
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        for expense in monthlyExpenses {
            if expense.modificationDate?.convertToMonth() == self.navigationItem.title {
                let expenseAmount = Double(expense.amount!)
                
                if expense.expense {
                    sum = sum - expenseAmount!
                } else if expense.income {
                    sum = sum + expenseAmount!
                }
            }
        }
        if let currentMonth = self.month {
            UserDefaults.standard.set(sum, forKey: "\(currentMonth)Total")
        }
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "changeTransaction2" {
                let indexPath = tableView.indexPathForSelectedRow!
                let expense = monthlyExpenses[indexPath.row]
                
                let displayNewTransactionController = segue.destination as! NewTransactionController
                displayNewTransactionController.newExpenses = expense
                
                UserDefaults.standard.set(expense.category, forKey: "selectedCategory")
                
                UserDefaults.standard.set(expense.collection, forKey: "selectedCollection")
                
                UserDefaults.standard.set(expense.currency, forKey: "selectedCurrencyCode")
                
                UserDefaults.standard.set(expense.currencyName, forKey: "selectedCurrencyName")
                
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if monthlyExpenses.count == 0{
            noExpenseLabel.isHidden = false
        }
        
        return monthlyExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthlyCell", for: indexPath) as! MonthlyExpenseTableViewCell
        
        let row = indexPath.row
        let expense = monthlyExpenses[row]
        
        for expense in monthlyExpenses {
            if expense.modificationDate?.convertToMonth() != navigationItem.title{
                if let expenseSorter = monthlyExpenses.index(of: expense) {
                    monthlyExpenses.remove(at: expenseSorter)
                }
            }
        }
        
        CoreDataHelper.save()
        
        var expenseAmountCalculating:Double = Double(expense.amount!)!
        var expenseAmountDisplayed:String = convertToMoney(expenseAmountCalculating)
        
        var finalDisplayed:String = expense.currencySymbol! + " " + expenseAmountDisplayed
        
        print(finalDisplayed)
        
        cell.expenseName2.text = expense.name
        cell.expenseAmount2.text = finalDisplayed
        cell.expenseCategory2.text = expense.category
        cell.expenseCollection2.text = expense.collection
        
        if expense.expense {
            cell.expenseAmount2.textColor = UIColor.red
        }
        else if expense.income{
            cell.expenseAmount2.textColor = UIColor.green
        }
        
        if expense.cash && expense.expense{
            cell.cashOrCredit.image = #imageLiteral(resourceName: "Cash-Expense Icon")
            
        }
        else if expense.cash && expense.income{
            cell.cashOrCredit.image = #imageLiteral(resourceName: "Cash-Income Icon")
            
        }
        else if expense.credit && expense.income{
            cell.cashOrCredit.image = #imageLiteral(resourceName: "Credit-Income Icon")
            
        }
        else if expense.credit && expense.income{
            cell.cashOrCredit.image = #imageLiteral(resourceName: "Credit-Expense Icon")
            
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63.5
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let collection = monthlyExpenses[indexPath.row]
            CoreDataHelper.deleteExpense(expense: collection)
            monthlyExpenses.remove(at: indexPath.row )
            monthlyExpenses = CoreDataHelper.retrieveExpenses()
        }
    }
}
