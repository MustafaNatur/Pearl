import Foundation

public struct Task: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public var title: String
    public var note: String?
    public var deadline: Date?
    
    public init(
        title: String,
        note: String? = nil,
        deadline: Date? = nil
    ) {
        self.title = title
        self.note = note
        self.deadline = deadline
    }
}

extension Task {
    @MainActor public static let mock = Task(
        title: "Sample Task",
        note: "This is a sample task note",
        deadline: Calendar.current.date(byAdding: .day, value: 7, to: Date())
    )
}
