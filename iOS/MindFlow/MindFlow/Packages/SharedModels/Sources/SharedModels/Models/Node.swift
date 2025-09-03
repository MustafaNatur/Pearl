import SwiftUI

public struct Node: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public var isCompleted: Bool
    public var position: CGPoint
    public var task: Task

    public init(
        isCompleted: Bool = false,
        position: CGPoint,
        task: Task
    ) {
        self.isCompleted = isCompleted
        self.position = position
        self.task = task
    }
}

extension Node {
    @MainActor static let mock = Node(
        isCompleted: false,
        position: .zero,
        task: Task(
            title: "Title",
            note: "Description",
            deadline: .now
        )
    )
}
