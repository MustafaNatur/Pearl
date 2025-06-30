//
//  DateService.swift
//  App
//
//  Created by Mustafa on 30.06.2025.
//
import Foundation

protocol DateService {
    func getCurrentFormattedDate() -> String
}

final class DateServiceImpl: DateService {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }()
    
    func getCurrentFormattedDate() -> String {
        dateFormatter.string(from: Date())
    }
}
