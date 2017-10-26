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

class CollectionDisplayViewController:UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var collectionExpenses = [Expense]() {
        didSet {
            tableView.reloadData()
        }
    }
    @IBOutlet weak var noExpenseLabel: UILabel!
    
    var collectionNow:String?
    
    var collectionSum:Double = 0.00
    
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
        
        self.collectionExpenses = CoreDataHelper.retrieveExpenses()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for expense in collectionExpenses {
            if expense.collection == navigationItem.title{
                let expenseAmount = Double(expense.amount!)
                if expense.expense {
                    collectionSum = collectionSum - expenseAmount!
                }
                else if expense.income {
                    collectionSum = collectionSum + expenseAmount!
                }
            }
        }
        if let currentCollection = self.collectionNow {
            UserDefaults.standard.set(collectionSum, forKey: "\(currentCollection)Total")
        }
        print(collectionSum)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "changeTransaction3" {
                let indexPath = tableView.indexPathForSelectedRow!
                let expense = collectionExpenses[indexPath.row]
                
                let displayNewTransactionController = segue.destination as! NewTransactionController
                displayNewTransactionController.newExpenses = expense
                
                UserDefaults.standard.set(expense.category, forKey: "selectedCategory")
                
                UserDefaults.standard.set(expense.collection, forKey: "selectedCollection")
                
                UserDefaults.standard.set(expense.currencyName, forKey: "selectedCurrencyName")
                
                UserDefaults.standard.set(expense.currency, forKey: "selectedCurrencyCode")
                
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collectionExpenses.count == 0{
            noExpenseLabel.isHidden = false
        }
        return collectionExpenses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 63.5;//Creating custom row height
    }
    
    
    func convertToMoney(_ money:Double)->String{
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return(numberFormatter.string(for: money))!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
        CoreDataHelper.save()
        
        var expenseAmountCalculating:Double = Double(expense.amount!)!
        var expenseAmountDisplayed:String = convertToMoney(expenseAmountCalculating)
        
        var finalDisplayed:String = expense.currencySymbol! + " " + expenseAmountDisplayed
        cell.expenseName.text = expense.name
        cell.expenseDate.text = expense.modificationDate?.convertToString()
        cell.expenseAmount.text = finalDisplayed
        cell.expenseCategory.text = expense.category
        
        if expense.expense {
            cell.expenseAmount.textColor = UIColor.red
        }
        else if expense.income {
            cell.expenseAmount.textColor = UIColor(red:0.49, green:0.83, blue:0.13, alpha:1.0)
            
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let collection = collectionExpenses[indexPath.row]
            CoreDataHelper.deleteExpense(expense: collection)
            collectionExpenses.remove(at: indexPath.row )
            collectionExpenses = CoreDataHelper.retrieveExpenses()
        }
    }
}
