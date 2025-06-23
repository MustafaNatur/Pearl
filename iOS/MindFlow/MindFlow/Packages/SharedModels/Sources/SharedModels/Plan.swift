import Foundation

public struct Plan: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let description: String?
    public let emoji: String
    public let overallStepsCount: Int
    public let finishedStepsCount: Int
    public let color: String

    public init(
        id: String,
        title: String,
        description: String?,
        emoji: String,
        overallStepsCount: Int,
        finishedStepsCount: Int,
        color: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.emoji = emoji
        self.overallStepsCount = overallStepsCount
        self.finishedStepsCount = finishedStepsCount
        self.color = color
    }
}

extension Plan {
    public static let mock = Plan(
        id: "1",
        title: "Learn Swift",
        description: "Complete guide to mastering Swift programming language with hands-on projects",
        emoji: "💻",
        overallStepsCount: 25,
        finishedStepsCount: 12,
        color: "#007AFF"
    )
}

extension [Plan] {
    public static let mockArray: [Plan] = [
        Plan(
            id: "1",
            title: "Learn Swift",
            description: "Complete guide to mastering Swift programming language with hands-on projects",
            emoji: "💻",
            overallStepsCount: 25,
            finishedStepsCount: 12,
            color: "#007AFF"
        ),
        Plan(
            id: "2",
            title: "Master SwiftUI",
            description: "Build beautiful iOS apps with SwiftUI framework",
            emoji: "📱",
            overallStepsCount: 30,
            finishedStepsCount: 8,
            color: "#FF3B30"
        ),
        Plan(
            id: "3",
            title: "Learn Arabic Language",
            description: "Complete Arabic language course from beginner to advanced",
            emoji: "🇸🇦",
            overallStepsCount: 100,
            finishedStepsCount: 45,
            color: "#34C759"
        ),
        Plan(
            id: "4",
            title: "Fitness Journey",
            description: nil,
            emoji: "💪",
            overallStepsCount: 60,
            finishedStepsCount: 60,
            color: "#FF9500"
        ),
        Plan(
            id: "5",
            title: "Photography Skills",
            description: "Learn professional photography techniques and editing",
            emoji: "📸",
            overallStepsCount: 15,
            finishedStepsCount: 3,
            color: "#AF52DE"
        )
    ]
}
