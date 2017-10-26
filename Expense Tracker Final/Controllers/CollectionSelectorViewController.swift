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

class CollectionSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var collection : Collections?
    
    var collectionToBeDisplayed = [Collections](){
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionDisplayLabel: UILabel!
    
    override func viewDidLoad() {
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        tableView.reloadData()
        self.collectionToBeDisplayed = CoreDataHelper.retrieveCollections()
        
        collectionDisplayLabel.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collectionToBeDisplayed.count == 0{
            collectionDisplayLabel.isHidden = false
        }
        
        return collectionToBeDisplayed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionDisplayCell", for: indexPath) as! CollectionTableViewCell
        let row = indexPath.row
        let collections = collectionToBeDisplayed[row]
        cell.collectionLabel.text = collections.title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        UserDefaults.standard.set(collectionToBeDisplayed[indexPath.row].title!, forKey: "selectedCollection")
        self.collection = collectionToBeDisplayed[indexPath.row]
        
        performSegue(withIdentifier: "unwindToNewTransactionViewController", sender: self)
        
    }
}
