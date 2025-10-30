import SwiftUI

public struct Node: Identifiable, Hashable, Sendable {
    public let id: String
    public var task: Task
    public var position: CGPoint

    public init(
        id: String,
        task: Task,
        position: CGPoint
    ) {
        self.id = id
        self.task = task
        self.position = position
    }
}

extension Node {
    @MainActor static let mock = Node(
        id: "",
        task: Task(
            title: "Title",
            note: "Description",
            dateDeadline: .now,
            timeDeadline: .now,
            isCompleted: false
        ),
        position: .zero
    )
}
