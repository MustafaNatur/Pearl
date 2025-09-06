import SwiftUI

public struct Node: Identifiable, Equatable, Sendable {
    public let id: String
    public var isCompleted: Bool
    public var position: CGPoint
    public var task: Task

    public init(
        id: String,
        isCompleted: Bool = false,
        position: CGPoint,
        task: Task
    ) {
        self.id = id
        self.isCompleted = isCompleted
        self.position = position
        self.task = task
    }
}

extension Node {
    @MainActor public static let mock = Node(
        id: "1",
        isCompleted: false,
        position: .zero,
        task: Task(
            title: "Title",
            note: "Description",
            deadline: .now
        )
    )
}
