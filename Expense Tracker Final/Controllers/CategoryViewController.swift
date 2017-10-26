//
//  CategoryViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 4/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var categories = [Category]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var noCategoryLabel: UILabel!
    
    @IBAction func addCategoryButton(_ sender: Any) {
        let alert = UIAlertController(title: "Create New Category", message: "", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            guard let textField = alert.textFields?.first,
                let categoryToSave = textField.text else {
                    return
            }
            
            let newCategory:Category = CoreDataHelper.createNewCategory()
            newCategory.title = categoryToSave
            
            CoreDataHelper.save()
            self.categories = CoreDataHelper.retrieveCategories()
            
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Category Name"
            textField.clearButtonMode = .whileEditing
        }
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        if (categories.count == 0) {
        }
        super.viewDidLoad()
        self.categories = CoreDataHelper.retrieveCategories()
        tableView.reloadData()
        
        noCategoryLabel.isHidden = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories.count == 0 {
            noCategoryLabel.isHidden = false
        }
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        let row = indexPath.row
        let category = categories[row]
        cell.categoryLabel.text = category.title
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        UserDefaults.standard.set(categories[indexPath.row].title!, forKey: "selectedCategory")
        performSegue(withIdentifier: "unwindToNewTransactionViewController", sender: self)
        
    }
}


