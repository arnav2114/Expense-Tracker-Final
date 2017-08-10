//
//  CollectionDisplayTableTableViewCell.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 9/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CollectionDisplayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var expenseName:UILabel!
    @IBOutlet weak var expenseAmount:UILabel!
    @IBOutlet weak var expenseDate:UILabel!
    @IBOutlet weak var  expenseCategory:UILabel!
    @IBOutlet weak var  expenseCurrency:UILabel!

}
