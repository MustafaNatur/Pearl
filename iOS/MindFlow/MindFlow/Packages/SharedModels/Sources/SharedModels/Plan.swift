import Foundation

public struct Plan {
    let title: String
    let description: String?
    let emoji: String
    let overallStepsCount: Int
    let finishedStepsCount: Int
    let color: String

    public init(
        title: String,
        description: String?,
        emoji: String,
        overallStepsCount: Int,
        finishedStepsCount: Int,
        color: String
    ) {
        self.title = title
        self.description = description
        self.emoji = emoji
        self.overallStepsCount = overallStepsCount
        self.finishedStepsCount = finishedStepsCount
        self.color = color
    }
}
