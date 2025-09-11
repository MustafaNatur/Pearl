//
//  Date+Extensions.swift
//  UIToolBox
//
//  Created by Mustafa on 08.09.2025.
//

import Foundation

extension Date {
    public var formattedString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "E, d MMMM, HH:mm"
        let formattedDate = formatter.string(from: self)
        return formattedDate
    }
}
