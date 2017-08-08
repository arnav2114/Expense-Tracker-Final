//
//  MainScreenController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 5/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit

class MainScreenController: UIViewController {
    
     @IBOutlet weak var todayDate: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        //dateLabel.text = NSDate().convertToString()
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEE, MMMM d"
        let result = formatter.string(from: date)
        
       todayDate.text = result
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMMM yyyy"
        let result = formatter.string(from: date)
        
        self.navigationItem.title = result

    }
    
    @IBAction func unwindToMainScreenController(_ segue: UIStoryboardSegue) {
        
    }
}

extension MainScreenController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
}
