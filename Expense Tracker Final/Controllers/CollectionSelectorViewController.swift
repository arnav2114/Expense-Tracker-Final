//
//  CollectionSelectorViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 7/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CollectionSelectorViewController: UITableViewController {
    
    var collection : Collections?
    
    var collectionToBeDisplayed = [Collections](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        self.collectionToBeDisplayed = CoreDataHelper.retrieveCollections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return collectionToBeDisplayed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionDisplayCell", for: indexPath) as! CollectionTableViewCell
        let row = indexPath.row
        let collections = collectionToBeDisplayed[row]
        cell.collectionLabel.text = collections.title
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        UserDefaults.standard.set(collectionToBeDisplayed[indexPath.row].title!, forKey: "selectedCollection")
        self.collection = collectionToBeDisplayed[indexPath.row]
        performSegue(withIdentifier: "unwindToNewTransactionViewController", sender: self)
        
    }
}
