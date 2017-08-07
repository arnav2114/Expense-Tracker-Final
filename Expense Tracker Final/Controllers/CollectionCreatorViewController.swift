//
//  CollectionCreateViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 5/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit

class CollectionCreatorViewController: UIViewController {
    
    override func viewDidLoad() {
        print ("")
    }
    
     var collections:[String] = []

    @IBAction func addCollectionButton(_ sender: Any) {
        let alert = UIAlertController(title: "Create New Category", message: "", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            var newCollectionName = alert.textFields![0]
            self.collections.append(newCollectionName.text!)
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
}

extension CollectionCreatorViewController: UITableViewDelegate   {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionMainCell", for: indexPath) as! CollectionCreatorTableViewCell
        
        cell.collectionName.text = collections[indexPath.row]
        
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}





