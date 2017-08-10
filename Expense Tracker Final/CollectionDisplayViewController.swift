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

class CollectionDisplayViewController:UITableViewController {
    
    var collectionExpenses = [Expense]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backItem?.title = "Back"
        
        self.collectionExpenses = CoreDataHelper.retrieveExpenses()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionExpenses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionGroupCell", for: indexPath) as! CollectionDisplayTableViewCell
        
        let row = indexPath.row
        let expense = collectionExpenses[row]
        
        for expense in collectionExpenses {
            if expense.collection != navigationItem.title{
                if let expenseSorter = collectionExpenses.index(of: expense) {
                    collectionExpenses.remove(at: expenseSorter)
                }
            }
        }
        
        cell.expenseName.text = expense.name
        cell.expenseDate.text = expense.modificationDate?.convertToString()
        cell.expenseAmount.text = expense.amount 
        cell.expenseCategory.text = expense.category
        cell.expenseCurrency.text = expense.currency
        
        if expense.expense {
            cell.expenseAmount.textColor = UIColor.red
            cell.expenseCurrency.textColor = UIColor.red
        }
        else if expense.income {
            cell.expenseAmount.textColor = UIColor.green
            cell.expenseCurrency.textColor = UIColor.green

        }
        
        return cell
    }
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if indexPath.row != nil {
                let collection = collectionExpenses[indexPath.row]
                CoreDataHelper.deleteExpense(expense: collection)
                collectionExpenses.remove(at: indexPath.row )
                collectionExpenses = CoreDataHelper.retrieveExpenses()
            }
    }
}
}
