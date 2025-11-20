import SwiftUI

public struct Node: Identifiable, Hashable, Sendable {
    public let id: String
    public var task: Task
    public var position: CGPoint
    public var scale: CGFloat

    public init(
        id: String,
        task: Task,
        position: CGPoint,
        scale: CGFloat
    ) {
        self.id = id
        self.task = task
        self.position = position
        self.scale = scale
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
        position: .zero,
        scale: 1
    )
}
