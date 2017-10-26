//
//  CollectionCreateViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 5/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CollectionCreatorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var noCollectionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var collections = [Collections]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    var collectionExpensesDelete = [Expense]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var totalAmountDisplayed2:String = ""
    
    var collectionNamePassed:String = ""
    
    var collectionsTotal:[Double] = []
    
    @IBAction func addCollectionButton(_ sender: Any) {
        let alert = UIAlertController(title: "Create New Collection", message: "", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            guard let textField = alert.textFields?.first,
                let collectionToSave = textField.text else {
                    return
            }
            
            let newCollections:Collections = CoreDataHelper.createNewCollection()
            newCollections.title = collectionToSave
            
            
            CoreDataHelper.save()
            self.collections = CoreDataHelper.retrieveCollections()
            self.tableView.reloadData()
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Collection Name"
            textField.clearButtonMode = .whileEditing
        }
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func convertToMoney(_ money:Double)->String{
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return(numberFormatter.string(for: money))!
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
        self.collections = CoreDataHelper.retrieveCollections()
        self.collectionExpensesDelete = CoreDataHelper.retrieveExpenses()
        tableView.reloadData()
        
        noCollectionLabel.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        noCollectionLabel.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collections = CoreDataHelper.retrieveCollections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collections.count == 0 {
            noCollectionLabel.isHidden = false
        }
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        collectionsTotal = collections.map {_ in 0}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as! CollectionCreatorTableViewCell
        
        let row = indexPath.row
        let collection1 = collections[row]
        
        cell.collectionName.text = collection1.title!
        
        for i in 0..<collectionsTotal.count {
            collectionsTotal[i] = (UserDefaults.standard.double(forKey:"\(collections[i].title!)Total"))
        }
        
        cell.totalCollectionExpense.text = convertToMoney(collectionsTotal[indexPath.row])
        
        if collectionsTotal[indexPath.row]>=0{
        cell.totalCollectionExpense.textColor = UIColor(red:0.49, green:0.83, blue:0.13, alpha:1.0)
        }
        else if collectionsTotal[indexPath.row]<0{
            cell.totalCollectionExpense.textColor = UIColor.red
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let collectionDisplayController = segue.destination as! CollectionDisplayViewController
        collectionDisplayController.navigationItem.title = collectionNamePassed
        collectionDisplayController.collectionNow = collectionNamePassed
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 63.5;//Creating custom row height
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(collectionsTotal[indexPath.row])
        
        collectionNamePassed = collections[indexPath.row].title!
        
        performSegue(withIdentifier: "displayCollection", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.collections = CoreDataHelper.retrieveCollections()
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let refreshAlert = UIAlertController(title: "Delete Collection", message: "All expenses in this collection will also be lost.", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                let collection = self.collections[indexPath.row]
                print(self.collections[indexPath.row].title!)
                for expense in self.collectionExpensesDelete{
                    if expense.collection == self.collections[indexPath.row].title{
                        if let expenseDeleter = self.collectionExpensesDelete.index(of: expense) {
                            self.collectionExpensesDelete.remove(at: expenseDeleter)
                            CoreDataHelper.deleteExpense(expense: expense)
                        }
                    }
                }
                CoreDataHelper.deleteCollection(collection: collection)
                self.collections.remove(at: indexPath.row)
                self.collections = CoreDataHelper.retrieveCollections()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                self.collections = CoreDataHelper.retrieveCollections()
            }))
            present(refreshAlert, animated: true, completion: nil)
            
        }
        
    }
}


