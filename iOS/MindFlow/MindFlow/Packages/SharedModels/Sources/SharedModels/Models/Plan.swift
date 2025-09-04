import Foundation

public struct Plan: Identifiable, Sendable, Equatable {
    public let id: String
    public let title: String
    public let overallStepsCount: Int
    public let finishedStepsCount: Int
    public let color: String
    public let startDate: Date
    public let nextDeadlineDate: Date?
    public let mindMapId: String

    public init(
        id: String,
        title: String,
        overallStepsCount: Int,
        finishedStepsCount: Int,
        color: String,
        startDate: Date,
        nextDeadlineDate: Date?,
        mindMapId: String
    ) {
        self.id = id
        self.title = title
        self.overallStepsCount = overallStepsCount
        self.finishedStepsCount = finishedStepsCount
        self.color = color
        self.startDate = startDate
        self.nextDeadlineDate = nextDeadlineDate
        self.mindMapId = mindMapId
    }
}

extension Plan {
    @MainActor public static var mock: Plan {
        Plan(
            id: UUID().uuidString,
            title: "Learn Swift",
            overallStepsCount: 25,
            finishedStepsCount: 12,
            color: "#007AFF",
            startDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
            nextDeadlineDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            mindMapId: UUID().uuidString
        )
    }
}

extension [Plan] {
    @MainActor public static let mockArray: [Plan] = Array(repeating: Plan.mock, count: 3)
}
