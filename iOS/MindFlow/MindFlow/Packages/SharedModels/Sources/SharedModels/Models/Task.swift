import Foundation

public struct Task: Identifiable, Hashable, Sendable {
    public let id = UUID()
    public var title: String
    public var note: String?
    public var dateDeadline: Date?
    public var timeDeadline: Date?
    public var isCompleted: Bool
    
    public init(
        title: String,
        note: String? = nil,
        dateDeadline: Date? = nil,
        timeDeadline: Date? = nil,
        isCompleted: Bool = false
    ) {
        self.title = title
        self.note = note
        self.dateDeadline = dateDeadline
        self.timeDeadline = timeDeadline
        self.isCompleted = isCompleted
    }
}

extension Task {
    public var deadlineString: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")

        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US")
        timeFormatter.dateFormat = "HH:mm"

        var deadlineComponents: [String] = []

        if let dateDeadline = dateDeadline {
            dateFormatter.dateFormat = "E, d MMMM"
            deadlineComponents.append(dateFormatter.string(from: dateDeadline))
        }

        if let timeDeadline = timeDeadline {
            deadlineComponents.append(timeFormatter.string(from: timeDeadline))
        }

        return deadlineComponents.isEmpty ? nil : deadlineComponents.joined(separator: ", ")
    }
}

extension Task: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title &&
        lhs.note == rhs.note &&
        lhs.dateDeadline == rhs.dateDeadline &&
        lhs.timeDeadline == rhs.timeDeadline &&
        lhs.isCompleted == rhs.isCompleted
    }
}

extension Task {
    @MainActor public static let mock = Task(
        title: "Sample Task",
        note: "This is a sample task note",
        dateDeadline: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
        timeDeadline: Calendar.current.date(byAdding: .hour, value: 9, to: Date()),
        isCompleted: false
    )
}
