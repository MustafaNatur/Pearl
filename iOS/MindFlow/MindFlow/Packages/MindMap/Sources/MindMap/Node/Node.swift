import SwiftUI

struct Node: Identifiable, Equatable {
    let id: UUID
    var isCompleted: Bool
    var title: String
    var description: String
    var deadLine: Date?
    var position: CGPoint
}

extension Node {
    static let mock = Node(
        id: UUID(),
        isCompleted: false,
        title: "Title",
        description: "Description",
        deadLine: .now,
        position: .zero
    )
}
