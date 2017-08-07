//
//  NewTransactionViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 3/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit


class NewTransactionController: UIViewController {
    
     var dataArray:[String] = ["Category", "Method", "Currency", "Album"]
    
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var expenseLabel: UITextField!
    @IBOutlet weak var amountLabel: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        amountLabel.layer.cornerRadius = 0.0
        expenseLabel.layer.cornerRadius = 0.0
        
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        //dateLabel.text = NSDate().convertToString()
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let result = formatter.string(from: date)
        
        dateLabel.text = result
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "categorySelect" {
            } else if identifier == "albumSelect" {
            }
            else if identifier == "currencySelect"{
            }
        }
    }
    
}

extension NewTransactionController: UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListDataTableViewCell
        
        cell.dataTitleLabel.text = dataArray[indexPath.row]

        if indexPath.row == 0{
            cell.methodType.isHidden = true
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        } else if indexPath.row == 1 {
            cell.methodType.isHidden = false
            cell.optionSelectedLabel.isHidden = true
            
        } else if indexPath.row == 2{
            cell.methodType.isHidden = true
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        } else if indexPath.row == 3{
            cell.methodType.isHidden = true
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
      return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
extension NewTransactionController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.performSegue(withIdentifier: "categorySelect", sender: (Any).self)
        } else if indexPath.row == 2{
            self.performSegue(withIdentifier: "currencySelect", sender: (Any).self)
        } else if indexPath.row == 3{
            self.performSegue(withIdentifier: "albumSelect", sender: (Any).self)
        }
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
