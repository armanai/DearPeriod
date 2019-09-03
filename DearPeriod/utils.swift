//
//  utils.swift
//  DearPeriod
//
//  Created by Armana Imširević, Klara Raškaj on 26/11/2018.
//  Copyright © 2018 Armana Imširević, Klara Raškaj. All rights reserved.
//

import Foundation
import UIKit

class Utils{
    static func formatDate(date: Date, format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        return formatter.string(from: date)
    }
    
    static func getDateFromString(stringDate: String, format: String) -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        return formatter.date(from: stringDate)
    }
    
    static func secondsToDays(seconds: Double) -> Int {
        return Int((seconds / 3600) / 24)
    }
    
    static func addDaysToDate(days: Int, toDate: Date) -> Date?{
        return Calendar.current.date(byAdding: .day, value: days, to: toDate)
    }
    
    static func addYearsToDate(years: Int, toDate: Date) -> Date?{
        return Calendar.current.date(byAdding: .year, value: years, to: toDate)
    }
    
    static func isTheSameDate(date1: Date, date2: Date) -> Bool{
        return formatDate(date: date1, format: "dd.MM.yyyy") == formatDate(date: date2, format: "dd.MM.yyyy")
    }
    
    static func showAlert(view: UIViewController,title: String?, message: String?, preferredStyle: UIAlertController.Style?, closeButtonTitle: String? = "Close") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle ?? .alert)
        alert.addAction(UIAlertAction(title: closeButtonTitle, style: .default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
