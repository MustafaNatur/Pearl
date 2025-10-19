import Foundation

public struct Connection: Identifiable, Sendable, Equatable {
    public let id: String
    public let fromNodeId: String
    public let toNodeId: String

    public init(
        id: String,
        fromNodeId: String,
        toNodeId: String
    ) {
        self.id = id
        self.fromNodeId = fromNodeId
        self.toNodeId = toNodeId
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        (lhs.fromNodeId == rhs.fromNodeId && lhs.toNodeId == rhs.toNodeId) ||
        (lhs.fromNodeId == rhs.toNodeId && lhs.toNodeId == rhs.fromNodeId)
    }
}
