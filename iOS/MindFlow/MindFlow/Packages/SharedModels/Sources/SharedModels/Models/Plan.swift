import Foundation

public struct Plan: Identifiable, Sendable, Equatable {
    public let id: String
    public let title: String
    public let overallStepsCount: Int
    public let finishedStepsCount: Int
    public let color: String
    public let startDate: Date
    public let nextDeadlineDate: Date?
    public var mindMap: MindMap

    public init(
        id: String,
        title: String,
        overallStepsCount: Int,
        finishedStepsCount: Int,
        color: String,
        startDate: Date,
        nextDeadlineDate: Date?,
        mindMap: MindMap
    ) {
        self.id = id
        self.title = title
        self.overallStepsCount = overallStepsCount
        self.finishedStepsCount = finishedStepsCount
        self.color = color
        self.startDate = startDate
        self.nextDeadlineDate = nextDeadlineDate
        self.mindMap = mindMap
    }
}

extension Plan {
    @MainActor public static let mock = Plan(
        id: "1",
        title: "Learn Swift",
        overallStepsCount: 25,
        finishedStepsCount: 12,
        color: "#007AFF",
        startDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
        nextDeadlineDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
        mindMap: .empty
    )
}

extension [Plan] {
    @MainActor public static let mockArray: [Plan] = [
        Plan(
            id: "1",
            title: "Learn Swift",
            overallStepsCount: 25,
            finishedStepsCount: 12,
            color: "#007AFF",
            startDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
            nextDeadlineDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            mindMap: .empty
        ),
        Plan(
            id: "2",
            title: "Master SwiftUI",
            overallStepsCount: 30,
            finishedStepsCount: 8,
            color: "#FF3B30",
            startDate: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date(),
            nextDeadlineDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            mindMap: .empty
        ),
        Plan(
            id: "3",
            title: "Learn Arabic Language",
            overallStepsCount: 100,
            finishedStepsCount: 45,
            color: "#34C759",
            startDate: Calendar.current.date(byAdding: .day, value: -60, to: Date()) ?? Date(),
            nextDeadlineDate: Calendar.current.date(byAdding: .day, value: 14, to: Date()),
            mindMap: .empty
        )
    ]
}
