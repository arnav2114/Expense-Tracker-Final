//
//  NewTransactionViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 3/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class NewTransactionController: UIViewController {
    
    var dataArray:[String] = ["","Category", "Method", "Currency", "Collection"]
    var categoryDisplayed:String = ""
    var collectionsDisplayed:String = ""
    var currencyDisplayed:String = ""
    var currencyNameDisplayed:String = ""
    var currencySymbolDisplayed: String = ""
    var methodType: Bool? = nil
    
    let datePicker = UIDatePicker()
    
    var collection : Collections?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var expenseLabel: UITextField!
    @IBOutlet weak var amountLabel: UITextField!
    @IBOutlet weak var dateChosenLabel: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var expenseType: UISegmentedControl!
    
    
    var newExpenses: Expense?
    
    func createDatePicker() {
        
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        dateChosenLabel.inputAccessoryView = toolbar
        
        dateChosenLabel.inputView = datePicker
        
    }
    
    func donePressed() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MM/dd/yyyy"
        let result = formatter.string(from: datePicker.date)
        
        dateChosenLabel.text = result
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        expenseType.tintColor = UIColor(red:0.00, green:0.74, blue:0.63, alpha:1.0)
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        createDatePicker()
        
        if let expense = newExpenses {
            let indexpath = NSIndexPath(row: 0, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexpath as IndexPath) as! ListDataTableViewCell
            
            expenseLabel.text = expense.name
            amountLabel.text = expense.amount
            
            datePicker.setDate(expense.modificationDate! as Date, animated: false)
            
            dateChosenLabel.text = expense.modificationDate?.convertToDisplayingDate()
            
            if expense.income {
                expenseType.selectedSegmentIndex = 0;
            }
                
            else if expense.expense {
                expenseType.selectedSegmentIndex = 1;
            }
            
            expense.expense = false
            expense.income = false
            
            if expense.cash {
                cell.methodType.selectedSegmentIndex = 0;
            }
                
            else if expense.credit {
                cell.methodType.selectedSegmentIndex = 1;
            }
            
            expense.cash = false
            expense.credit = false

            
            if UserDefaults.standard.string(forKey: "selectedCategory") != nil {
                self.categoryDisplayed = expense.category!
                tableView.reloadData()
            }
            
            if UserDefaults.standard.string(forKey: "selectedCollection") != nil {
                self.collectionsDisplayed = expense.collection!
                tableView.reloadData()
            }
            
            if UserDefaults.standard.string(forKey: "selectedCurrencyCode") != nil {
                self.currencyDisplayed = expense.currency!
                tableView.reloadData()
            }
            
            if UserDefaults.standard.string(forKey: "selectedCurrencyName") != nil {
                self.currencyNameDisplayed = expense.currencyName!
                tableView.reloadData()
            }
            
            if UserDefaults.standard.string(forKey: "selectedCurrencySymbol") != nil {
                self.currencySymbolDisplayed = expense.currencySymbol!
                tableView.reloadData()
            }
        }
        
        amountLabel.layer.cornerRadius = 0.0
        expenseLabel.layer.cornerRadius = 0.0
        
        expenseLabel.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        amountLabel.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        dateChosenLabel.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if (!self.isMovingToParentViewController){

            self.categoryDisplayed = ""
            self.collectionsDisplayed = ""
            self.currencyDisplayed = ""
        }
        
        tableView.reloadData()

        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let result = formatter.string(from: date)
        
        dateLabel.text = result
        
        if let category = UserDefaults.standard.string(forKey: "selectedCategory") {
            self.categoryDisplayed = category
            tableView.reloadData()
            
        }
        
        if let collections = UserDefaults.standard.string(forKey: "selectedCollection") {
            self.collectionsDisplayed = collections
            tableView.reloadData()
            
        }
        
        if let currency = UserDefaults.standard.string(forKey: "selectedCurrencyCode") {
            self.currencyDisplayed = currency
            tableView.reloadData()
            
        }
        if let currency2 = UserDefaults.standard.string(forKey: "selectedCurrencyName") {
            self.currencyNameDisplayed = currency2
            tableView.reloadData()
            
        }
        if let currency3 = UserDefaults.standard.string(forKey: "selectedCurrencySymbol") {
            self.currencySymbolDisplayed = currency3
            tableView.reloadData()
            
        }
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexpath = NSIndexPath(row: 0, section: 0)
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexpath as IndexPath) as! ListDataTableViewCell
        
        if let identifier = segue.identifier {
            if identifier == "categorySelect" {
            } else if identifier == "albumSelect" {
            }
            else if identifier == "currencySelect"{
            }
            else if identifier == "saveExpense"{
                
                let expense = self.newExpenses ?? CoreDataHelper.newExpense()
                
                switch expenseType.selectedSegmentIndex{
                case 0: expense.income = true && expense.expense != true
                case 1: expense.expense = true && expense.income != true
                default:
                    break
                }
                
                switch cell.methodType.selectedSegmentIndex{
                case 0: expense.cash = true && expense.credit != true
                case 1: expense.credit = true && expense.cash != true
                default:
                    break
                }
                
                print(expense.income)
                
                expense.name = expenseLabel.text
                expense.category = categoryDisplayed
                expense.collection = collectionsDisplayed
                expense.amount = amountLabel.text
                expense.currency = currencyDisplayed
                expense.currencySymbol = currencySymbolDisplayed
                expense.currencyName = currencyNameDisplayed
                expense.modificationDate = datePicker.date as NSDate
                
                expenseLabel.text = nil
                amountLabel.text = nil
                dateChosenLabel.text = nil
                
                UserDefaults.standard.removeObject(forKey: "selectedCategory")
                UserDefaults.standard.removeObject(forKey: "selectedCollection")
                UserDefaults.standard.removeObject(forKey: "selectedCurrencyName")
                UserDefaults.standard.removeObject(forKey: "selectedCurrencySymbol")
                UserDefaults.standard.removeObject(forKey: "selectedCurrencyCode")
                
                CoreDataHelper.save()
                
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let indexpath = NSIndexPath(row: 0, section: 0)
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexpath as IndexPath) as! ListDataTableViewCell
        
        if expenseLabel.text == "" || amountLabel.text == "" || collectionsDisplayed == "" || categoryDisplayed == "" || currencyDisplayed == "" || dateChosenLabel.text == "" || expenseType.selectedSegmentIndex == UISegmentedControlNoSegment || cell.methodType.selectedSegmentIndex == UISegmentedControlNoSegment {
            let alert = UIAlertController(title: "Some Fields are Missing", message: "Please fill out all the fields", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
            
            cell.isHidden = true
            return false
        }
            
        else {
            CoreDataHelper.save()
        }
        
        
        return true
    }
}
extension NewTransactionController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListDataTableViewCell
        
        cell.dataTitleLabel.text = dataArray[indexPath.row]
        
        if indexPath.row == 0{
            cell.isHidden = true
        }
        
        else if indexPath.row == 1{
            cell.methodType.isHidden = true
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.optionSelectedLabel.isHidden = false
            cell.optionSelectedLabel.text! = categoryDisplayed
            cell.optionSelectedLabel.adjustsFontSizeToFitWidth = true
            
        } else if indexPath.row == 2 {
            cell.methodType.isHidden = false
            cell.methodType.tintColor = UIColor(red:0.00, green:0.74, blue:0.63, alpha:1.0)
            cell.optionSelectedLabel.isHidden = true
            cell.accessoryType = .none
            cell.selectionStyle = .none
            
        } else if indexPath.row == 3{
            cell.methodType.isHidden = true
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.optionSelectedLabel.isHidden = false
            cell.optionSelectedLabel.text! = currencyDisplayed
            cell.optionSelectedLabel.adjustsFontSizeToFitWidth = true
            cell.optionSelectedLabel.minimumScaleFactor = 0.2
            
        } else if indexPath.row == 4{
            cell.methodType.isHidden = true
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.optionSelectedLabel.isHidden = false
            cell.optionSelectedLabel.text! = collectionsDisplayed
            cell.optionSelectedLabel.adjustsFontSizeToFitWidth = true

            
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    @IBAction func unwindToNewTransactionViewController(_ segue: UIStoryboardSegue) {
    }
}

extension NewTransactionController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            self.performSegue(withIdentifier: "categorySelect", sender: (Any).self)
        } else if indexPath.row == 3{
            self.performSegue(withIdentifier: "currencySelect", sender: (Any).self)
        } else if indexPath.row == 4{
            self.performSegue(withIdentifier: "albumSelect", sender: (Any).self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}
