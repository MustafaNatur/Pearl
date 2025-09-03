import SwiftUI

public struct Node: Identifiable, Equatable {
    public let id = UUID()
    public var isCompleted: Bool
    public var title: String
    public var description: String
    public var deadLine: Date?
    public var position: CGPoint

    public init(
        isCompleted: Bool,
        title: String,
        description: String,
        deadLine: Date? = nil,
        position: CGPoint
    ) {
        self.isCompleted = isCompleted
        self.title = title
        self.description = description
        self.deadLine = deadLine
        self.position = position
    }
}

extension Node {
    nonisolated(unsafe) static let mock = Node(
        isCompleted: false,
        title: "Title",
        description: "Description",
        deadLine: .now,
        position: .zero
    )
}
