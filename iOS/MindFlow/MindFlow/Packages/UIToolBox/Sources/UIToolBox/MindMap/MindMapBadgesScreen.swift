import SwiftUI

public struct MindMapBadgesScreen: View {
    @State private var badges = MindMapBadge.BadgeData.mockData
    @State private var selectedFilter: FilterType = .all
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    HeaderSection
                    FilterSection
                    BadgesGrid
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Mind Map")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var HeaderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Project Progress")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Track your tasks and milestones")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var FilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(FilterType.allCases, id: \.self) { filter in
                    FilterButton(
                        filter: filter,
                        isSelected: selectedFilter == filter,
                        count: getFilterCount(filter)
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
    
    private var BadgesGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(filteredBadges, id: \.id) { badge in
                MindMapBadge(badge: badge) {
                    toggleBadgeCompletion(badge)
                }
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: filteredBadges.count)
    }
    
    private var filteredBadges: [MindMapBadge.BadgeData] {
        switch selectedFilter {
        case .all:
            return badges
        case .completed:
            return badges.filter { $0.isCompleted }
        case .pending:
            return badges.filter { !$0.isCompleted }
        case .highPriority:
            return badges.filter { $0.priority == .high || $0.priority == .critical }
        }
    }
    
    private func getFilterCount(_ filter: FilterType) -> Int {
        switch filter {
        case .all:
            return badges.count
        case .completed:
            return badges.filter { $0.isCompleted }.count
        case .pending:
            return badges.filter { !$0.isCompleted }.count
        case .highPriority:
            return badges.filter { $0.priority == .high || $0.priority == .critical }.count
        }
    }
    
    private func toggleBadgeCompletion(_ badge: MindMapBadge.BadgeData) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if let index = badges.firstIndex(where: { $0.id == badge.id }) {
                badges[index] = MindMapBadge.BadgeData(
                    id: badge.id,
                    title: badge.title,
                    description: badge.description,
                    isCompleted: !badge.isCompleted,
                    color: badge.color,
                    priority: badge.priority
                )
            }
        }
    }
}

// MARK: - Filter Types
enum FilterType: String, CaseIterable {
    case all = "All"
    case completed = "Completed"
    case pending = "Pending"
    case highPriority = "High Priority"
    
    var displayText: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .all: "square.grid.2x2"
        case .completed: "checkmark.circle"
        case .pending: "clock"
        case .highPriority: "exclamationmark.triangle"
        }
    }
}

// MARK: - Filter Button
struct FilterButton: View {
    let filter: FilterType
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: filter.icon)
                    .font(.caption)
                
                Text(filter.displayText)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text("(\(count))")
                    .font(.caption2)
                    .opacity(0.7)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.blue : Color(.systemGray5))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MindMapBadgesScreen()
} 