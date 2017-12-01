//
//  DateExtensions.swift
//  Outpost
//
//  Created by Robert Rozenvasser on 12/1/17.
//

import Foundation

extension Date {
    
    struct Formatter {
        static var shared: DateFormatter {
            let shared = DateFormatter()
            shared.locale = Locale(identifier: "en_US")
            return shared
        }
    }
    
    var string: String {
        let formatter = Formatter.shared
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
}
