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
    public var deadline: Date?

    public init(
        title: String,
        note: String?,
        deadline: Date?
    ) {
        self.title = title
        self.note = note
        self.deadline = deadline
    }
}
