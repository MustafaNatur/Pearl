//
//  Plan.swift
//  SharedModels
//
//  Created by Mustafa on 05.07.2025.
//

import Foundation
import SwiftData

@Model
public final class PlanScheme: Identifiable {
    @Attribute(.unique)
    public var identifier: String
    public var title: String
    public var overallStepsCount: Int
    public var finishedStepsCount: Int
    public var color: String
    public var startDate: Date
    public var nextDeadlineDate: Date?
    public var mindMap: MindMapScheme

    // Conformance to Identifiable
    public var id: String { identifier }

    public init(
        identifier: String,
        title: String,
        overallStepsCount: Int,
        finishedStepsCount: Int,
        color: String,
        startDate: Date,
        nextDeadlineDate: Date?,
        mindMap: MindMapScheme
    ) {
        self.identifier = identifier
        self.title = title
        self.overallStepsCount = overallStepsCount
        self.finishedStepsCount = finishedStepsCount
        self.color = color
        self.startDate = startDate
        self.nextDeadlineDate = nextDeadlineDate
        self.mindMap = mindMap
    }
}
