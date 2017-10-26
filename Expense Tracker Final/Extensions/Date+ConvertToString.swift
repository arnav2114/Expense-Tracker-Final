//
//  Date+ConvertToString.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 9/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation

/*extension Date {
    func convertToString() -> String {
        //let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MM/dd/yyyy"
        let result = formatter.dateFormat
        return result!
    }
}

extension NSDate {
    func convertToString() -> String {
        //let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MM/dd/yyyy"
        let result = formatter.dateFormat
        return result!
    }
}*/

extension Date {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: self as Date, dateStyle: DateFormatter.Style.medium, timeStyle: .none)
    }
}

extension NSDate {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: self as Date, dateStyle: DateFormatter.Style.medium, timeStyle: .none)
    }
}
extension NSDate {
    func convertToDisplayingDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MM/dd/yyyy"
        let result = formatter.string(from: self as Date)
        return result

    }
}

extension NSDate {
    func convertToMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let result = formatter.string(from: self as Date)
        return result
    }
}

extension NSDate {
    func convertToDM() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d"
        let result = formatter.string(from: self as Date)
        return result
    }
}




