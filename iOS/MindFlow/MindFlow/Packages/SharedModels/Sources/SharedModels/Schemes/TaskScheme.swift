//
//  File.swift
//  PlanRepository
//
//  Created by Mustafa on 01.09.2025.
//

import Foundation
import SwiftData

@Model
public final class TaskScheme {
    public var title: String
    public var note: String?
    public var dateDeadline: Date?
    public var timeDeadline: Date?
    public var isCompleted: Bool

    public init(
        title: String,
        note: String?,
        dateDeadline: Date?,
        timeDeadline: Date?,
        isCompleted: Bool
    ) {
        self.title = title
        self.note = note
        self.dateDeadline = dateDeadline
        self.timeDeadline = timeDeadline
        self.isCompleted = isCompleted
    }
}
