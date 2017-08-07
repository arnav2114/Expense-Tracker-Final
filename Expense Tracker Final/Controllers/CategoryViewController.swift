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

class CategoryViewController: UITableViewController {
    
    var categories:[NSManagedObject] = []{
        //"Food","Transportation","Medical Expense","Shopping","Entertainment","Private"
        didSet{
            tableView.reloadData()
        }
    }
    
    func save(newCategory: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Category", into: managedContext) as! Category
        
//        let newCreatedCategory = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
//        newCreatedCategory.setValue(newCategory, forKeyPath: "newCategory")
        
        // 4
        do {
            try managedContext.save()
            //categories.append(entity)
            print (categories)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addCategoryButton(_ sender: Any) {
        let alert = UIAlertController(title: "Create New Category", message: "", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            guard let textField = alert.textFields?.first,
                let categoryToSave = textField.text else {
                    return
            }
            //var newCategoryName = alert.textFields![0]
            //self.categories.append(newCategoryName.text!)
            self.save(newCategory: categoryToSave)
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
        
        tableView.reloadData()
        
       /* let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext*/
        
    /*let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: managedContext)*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Category")
        
        do {
            categories = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        let newCreatedCategory = categories[indexPath.row]
        
        cell.categoryLabel.text = newCreatedCategory.value(forKeyPath:"newCategory") as? String
        
        return cell
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}





