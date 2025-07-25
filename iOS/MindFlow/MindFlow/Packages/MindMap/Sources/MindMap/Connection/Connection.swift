import Foundation

struct Connection: Identifiable, Equatable {
    let id = UUID()
    let from: UUID
    let to: UUID

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.from == rhs.from && lhs.to == rhs.to ||
        lhs.from == rhs.to && lhs.to == rhs.from
    }
}
