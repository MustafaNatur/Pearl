import Foundation

public struct Plan: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let description: String?
    public let overallStepsCount: Int
    public let finishedStepsCount: Int
    public let color: String
    public let startDate: Date
    public let nextDeadlineDate: Date?

    public init(
        id: String,
        title: String,
        description: String?,
        overallStepsCount: Int,
        finishedStepsCount: Int,
        color: String,
        startDate: Date,
        nextDeadlineDate: Date?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.overallStepsCount = overallStepsCount
        self.finishedStepsCount = finishedStepsCount
        self.color = color
        self.startDate = startDate
        self.nextDeadlineDate = nextDeadlineDate
    }
}

extension Plan {
    public static let mock = Plan(
        id: "1",
        title: "Learn Swift",
        description: "Complete guide to mastering Swift programming language with hands-on projects",
        overallStepsCount: 25,
        finishedStepsCount: 12,
        color: "#007AFF",
        startDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
        nextDeadlineDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())
    )
}

extension [Plan] {
    public static let mockArray: [Plan] = [
        Plan(
            id: "1",
            title: "Learn Swift",
            description: "Complete guide to mastering Swift programming language with hands-on projects",
            overallStepsCount: 25,
            finishedStepsCount: 12,
            color: "#007AFF",
            startDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
            nextDeadlineDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())
        ),
        Plan(
            id: "2",
            title: "Master SwiftUI",
            description: "Build beautiful iOS apps with SwiftUI framework",
            overallStepsCount: 30,
            finishedStepsCount: 8,
            color: "#FF3B30",
            startDate: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date(),
            nextDeadlineDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())
        ),
        Plan(
            id: "3",
            title: "Learn Arabic Language",
            description: "Complete Arabic language course from beginner to advanced",
            overallStepsCount: 100,
            finishedStepsCount: 45,
            color: "#34C759",
            startDate: Calendar.current.date(byAdding: .day, value: -60, to: Date()) ?? Date(),
            nextDeadlineDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())
        ),
        Plan(
            id: "4",
            title: "Fitness Journey",
            description: nil,
            overallStepsCount: 60,
            finishedStepsCount: 60,
            color: "#FF9500",
            startDate: Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date(),
            nextDeadlineDate: nil // Completed plan, no next deadline
        ),
        Plan(
            id: "5",
            title: "Photography Skills",
            description: "Learn professional photography techniques and editing",
            overallStepsCount: 15,
            finishedStepsCount: 3,
            color: "#AF52DE",
            startDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
            nextDeadlineDate: Calendar.current.date(byAdding: .day, value: 21, to: Date())
        )
    ]
}
