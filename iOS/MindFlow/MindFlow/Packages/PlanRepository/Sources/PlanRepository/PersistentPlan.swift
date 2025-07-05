//
//  Plan.swift
//  PlanRepository
//
//  Created by Mustafa on 05.07.2025.
//


import Foundation
import SwiftData

@Model
final class PersistentPlan  {
    @Attribute(.unique)
    var identifier: String
    var title: String
    var overallStepsCount: Int
    var finishedStepsCount: Int
    var color: String
    var startDate: Date
    var nextDeadlineDate: Date?

    init(
        identifier: String,
        title: String,
        overallStepsCount: Int,
        finishedStepsCount: Int,
        color: String,
        startDate: Date,
        nextDeadlineDate: Date?
    ) {
        self.identifier = identifier
        self.title = title
        self.overallStepsCount = overallStepsCount
        self.finishedStepsCount = finishedStepsCount
        self.color = color
        self.startDate = startDate
        self.nextDeadlineDate = nextDeadlineDate
    }
}
