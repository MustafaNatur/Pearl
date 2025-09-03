import Foundation

public struct Connection: Identifiable, Sendable, Equatable {
    public let id = UUID()
    public let from: UUID
    public let to: UUID

    public init(from: UUID, to: UUID) {
        self.from = from
        self.to = to
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.from == rhs.from && lhs.to == rhs.to ||
        lhs.from == rhs.to && lhs.to == rhs.from
    }
}
