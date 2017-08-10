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
    
    var expenses = [Expense]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.expenses = CoreDataHelper.retrieveExpenses()
    
    }

    override func viewWillAppear(_ animated: Bool) {        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEE, MMMM d"
        let result = formatter.string(from: date)
        
        todayDate.text = result
        
        let formatter2 = DateFormatter()
        
        formatter2.dateFormat = "MMMM yyyy"
        let result2 = formatter2.string(from: date)
        
        self.navigationItem.title = result2


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
                
                if let category = UserDefaults.standard.string(forKey: "selectedCategory") {
                    displayNewTransactionController.categoryDisplayed = category
                    tableView.reloadData()
                    
                }
                
                if let collections = UserDefaults.standard.string(forKey: "selectedCollection") {
                    displayNewTransactionController.collectionsDisplayed = collections
                    tableView.reloadData()
                    
                }
                
                if let currency = UserDefaults.standard.string(forKey: "selectedCurrency") {
                    displayNewTransactionController.currencyDisplayed = currency
                    tableView.reloadData()
                    
                }

                
            }
        }
    }

}

extension MainScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return expenses.count
        //return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        
        let row = indexPath.row
        
        let expense = expenses[row]
        
        cell.expenseLabel.text = expense.name
        
        cell.expenseAmount.text = expense.amount 
        
        cell.expenseCategory.text = expense.category
        
        cell.expenseCollection.text = expense.collection
        
        cell.expenseCurrency.text = expense.currency
        
        if expense.expense {
            cell.expenseAmount.textColor = UIColor.red
            cell.expenseCurrency.textColor = UIColor.red
        }
        
        if expense.income {
            cell.expenseAmount.textColor = UIColor.green
            cell.expenseCurrency.textColor = UIColor.green
        }
        
        return cell
        
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
}

extension MainScreenController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if indexPath.row != nil {
                print(indexPath.row)
                let expense = expenses[indexPath.row]
                CoreDataHelper.deleteExpense(expense: expense)
                expenses.remove(at: indexPath.row)
                expenses = CoreDataHelper.retrieveExpenses()
            }

        }
    }

}



