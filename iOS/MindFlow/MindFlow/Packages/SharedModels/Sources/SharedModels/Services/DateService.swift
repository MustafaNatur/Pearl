//
//  DateService.swift
//  App
//
//  Created by Mustafa on 30.06.2025.
//
import Foundation

public protocol DateService {
    func getCurrentFormattedDate() -> String
}

public final class DateServiceImpl: DateService {
    public init() {}
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }()
    
    public func getCurrentFormattedDate() -> String {
        dateFormatter.string(from: Date())
    }
}
