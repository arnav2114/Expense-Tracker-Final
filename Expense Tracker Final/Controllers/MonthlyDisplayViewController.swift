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

class MonthlyDisplayViewController: UITableViewController {
    
    var sum:Int = 0
    var monthlyExpenses = [Expense]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var sumToBeStored: TotalExpense?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backItem?.title = "Back"
        
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        
        //if let totalExpense = sumToBeStored{
        
        
        for expense in monthlyExpenses {
            if expense.modificationDate?.convertToMonth() == navigationItem.title{
            let expenseAmount = Int(expense.amount!)
            if expense.expense {
                sum = sum - expenseAmount!
            }
            else if expense.income {
                sum = sum + expenseAmount!
            }
                expense.total = String(sum)
            UserDefaults.standard.set(expense.total, forKey: "totalAmount")            }
        }
        print(sum)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthlyExpenses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
        cell.expenseName2.text = expense.name
        cell.expenseDate2.text = expense.modificationDate?.convertToDM()
        cell.expenseAmount2.text = expense.amount
        cell.expenseCategory2.text = expense.category
        cell.expenseCurrency2.text = expense.currency
        cell.expenseCollection2.text = expense.collection
        
        if expense.expense {
            cell.expenseCurrency2.textColor = UIColor.red
            cell.expenseAmount2.textColor = UIColor.red
        }
        else if expense.income{
            cell.expenseCurrency2.textColor = UIColor.green
            cell.expenseAmount2.textColor = UIColor.green
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if indexPath.row != nil {
                let collection = monthlyExpenses[indexPath.row]
                CoreDataHelper.deleteExpense(expense: collection)
                monthlyExpenses.remove(at: indexPath.row )
                monthlyExpenses = CoreDataHelper.retrieveExpenses()
            }
        }
    }
}
