//
//  Plan.swift
//  SharedModels
//
//  Created by Mustafa on 05.07.2025.
//

import Foundation
import SwiftData

@Model
public final class PlanScheme {
    @Attribute(.unique)
    public var identifier: String
    public var title: String
    public var overallStepsCount: Int
    public var finishedStepsCount: Int
    public var color: String
    public var startDate: Date
    public var deadlineDate: Date?
    public var mindMapId: String

    public init(
        identifier: String,
        title: String,
        overallStepsCount: Int,
        finishedStepsCount: Int,
        color: String,
        startDate: Date,
        nextDeadlineDate: Date?,
        mindMapId: String
    ) {
        self.identifier = identifier
        self.title = title
        self.overallStepsCount = overallStepsCount
        self.finishedStepsCount = finishedStepsCount
        self.color = color
        self.startDate = startDate
        self.deadlineDate = nextDeadlineDate
        self.mindMapId = mindMapId
    }
}
