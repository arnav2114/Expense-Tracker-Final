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

class CollectionCreatorViewController: UITableViewController {
    var collections = [Collections]() {
            //"Food","Transportation","Medical Expense","Shopping","Entertainment","Private"
            didSet{
                tableView.reloadData()
            }
        }
    var totalAmountDisplayed2:String = ""
    var collectionNamePassed:String = ""
        
        @IBAction func addCollectionButton(_ sender: Any) {
            let alert = UIAlertController(title: "Create New Collection", message: "", preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
                // Get 1st TextField's text
                guard let textField = alert.textFields?.first,
                    let collectionToSave = textField.text else {
                        return
                }
                
                let newCollections:Collections = CoreDataHelper.createNewCollection()
                newCollections.title = collectionToSave
                
                CoreDataHelper.save()
                self.collections = CoreDataHelper.retrieveCollections()
                
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
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.collections = CoreDataHelper.retrieveCollections()
            tableView.reloadData()
            
        }
    
    override func viewDidAppear(_ animated: Bool) {
        if let total2 = UserDefaults.standard.string(forKey: "collectionTotal") {
            self.totalAmountDisplayed2 = total2
            tableView.reloadData()
        }
    }
    
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return collections.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as! CollectionCreatorTableViewCell
            
            let row = indexPath.row
            let collection1 = collections[row]
            cell.collectionName.text = collection1.title!
            cell.totalCollectionExpense.text = totalAmountDisplayed2
            
            

            return cell
        }
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let collectionDisplayController = segue.destination as! CollectionDisplayViewController
        collectionDisplayController.navigationItem.title = collectionNamePassed
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        collectionNamePassed = collections[indexPath.row].title!
        
        performSegue(withIdentifier: "displayCollection", sender: self)

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if indexPath.row != nil {
                let collection = collections[indexPath.row]
                CoreDataHelper.deleteCollection(collection: collection)
                collections.remove(at: indexPath.row)
                collections = CoreDataHelper.retrieveCollections()
            }
            
        }
    }
    
}
