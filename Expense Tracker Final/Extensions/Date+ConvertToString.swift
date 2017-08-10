//
//  Date+ConvertToString.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 9/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation

extension Date {
    func convertToString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MM/dd/yyyy"
        let result = formatter.string(from: date)
        return result
    }
}

extension NSDate {
    func convertToString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MM/dd/yyyy"
        let result = formatter.string(from: date)
        return result
    }
}

extension NSDate {
    func convertToMonth() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let result = formatter.string(from: date)
        return result
    }
}

extension NSDate {
    func convertToDM() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dth"
        let result = formatter.string(from: date)
        return result
    }
}
extension NSDate {
    func convertToTodayDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        let result = formatter.string(from: date)
        return result
    }
}




