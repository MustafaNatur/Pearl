import SwiftUI

public struct MindMapBadge: View {
    public struct BadgeData : Sendable{
        let id: String
        let title: String
        let description: String
        let isCompleted: Bool
        let color: String
        let priority: Priority
        
        public init(id: String, title: String, description: String, isCompleted: Bool, color: String, priority: Priority) {
            self.id = id
            self.title = title
            self.description = description
            self.isCompleted = isCompleted
            self.color = color
            self.priority = priority
        }
    }
    
    public enum Priority : Sendable{
        case low, medium, high, critical
        
        var displayText: String {
            switch self {
            case .low: "Low"
            case .medium: "Medium"
            case .high: "High"
            case .critical: "Critical"
            }
        }
        
        var priorityColor: Color {
            switch self {
            case .low: .green
            case .medium: .orange
            case .high: .red
            case .critical: .purple
            }
        }
    }
    
    private let badge: BadgeData
    private let onTap: () -> Void
    
    public init(badge: BadgeData, onTap: @escaping () -> Void = {}) {
        self.badge = badge
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Header
                Content
                Footer
            }
            .padding(16)
            .background(badgeBackground)
            .clipShape(.rect(cornerRadius: 16))
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            .scaleEffect(badge.isCompleted ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: badge.isCompleted)
        }
        .buttonStyle(.plain)
    }
    
    private var Header: some View {
        HStack {
            Text(badge.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(badge.isCompleted ? .secondary : .primary)
                .strikethrough(badge.isCompleted)
                .lineLimit(2)
            
            Spacer()
            
            CompletionBadge
        }
    }
    
    private var Content: some View {
        Text(badge.description)
            .font(.body)
            .foregroundColor(badge.isCompleted ? .secondary : .primary)
            .opacity(badge.isCompleted ? 0.7 : 1.0)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
    }
    
    private var Footer: some View {
        HStack {
            PriorityBadge
            
            Spacer()
            
            if badge.isCompleted {
                CompletedIndicator
            }
        }
    }
    
    private var CompletionBadge: some View {
        ZStack {
            Circle()
                .fill(badge.isCompleted ? Color(hex: badge.color) : Color.clear)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .stroke(Color(hex: badge.color), lineWidth: 2)
                        .opacity(badge.isCompleted ? 0 : 1)
                )
            
            if badge.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: badge.isCompleted)
    }
    
    private var PriorityBadge: some View {
        Text(badge.priority.displayText)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badge.priority.priorityColor)
            .clipShape(.rect(cornerRadius: 8))
    }
    
    private var CompletedIndicator: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption)
                .foregroundColor(.green)
            
            Text("Completed")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.green)
        }
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }
    
    private var badgeBackground: some ShapeStyle {
        if badge.isCompleted {
            return AnyShapeStyle(Color(.systemGray6))
        } else {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color(hex: badge.color).opacity(0.1),
                        Color(hex: badge.color).opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
}

// MARK: - Preview Data
extension MindMapBadge.BadgeData {
    static let mockData: [MindMapBadge.BadgeData] = [
        .init(
            id: "1",
            title: "Design User Interface",
            description: "Create wireframes and mockups for the new dashboard interface with modern design patterns",
            isCompleted: false,
            color: "#007AFF",
            priority: .high
        ),
        .init(
            id: "2",
            title: "Backend API Development",
            description: "Implement REST API endpoints for user authentication and data management",
            isCompleted: true,
            color: "#34C759",
            priority: .medium
        ),
        .init(
            id: "3",
            title: "Database Schema",
            description: "Design and optimize database schema for better performance",
            isCompleted: false,
            color: "#FF9500",
            priority: .critical
        ),
        .init(
            id: "4",
            title: "Testing & QA",
            description: "Write unit tests and perform quality assurance testing",
            isCompleted: false,
            color: "#AF52DE",
            priority: .low
        )
    ]
} 
