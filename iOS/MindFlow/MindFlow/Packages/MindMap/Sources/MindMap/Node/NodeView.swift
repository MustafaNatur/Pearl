import SwiftUI
import UIToolBox

struct NodeView: View {
    let title: String
    let description: String?
    let isCompleted: Bool
    let deadline: String?
    let isSelected: Bool
    let showControls: Bool
    let onTaskTapCompleted: () -> Void
    let onDeleteTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Title
                Spacer()
                CheckButton(isCompleted: isCompleted, onTap: onTaskTapCompleted)
            }
            
            if let description {
                Divider
                Subtitle(description)
            }
            Deadline
                .padding(.top, 12)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? Color.yellow : Color.clear, lineWidth: 3)
        )
        .overlay(alignment: .bottomLeading) {
            Controls
        }
        .aspectRatio(4/3, contentMode: .fit)
        .frame(maxWidth: 300)
    }

    private var Controls: some View {
        DeleteButton(action: onDeleteTapped)
            .offset(x: -25, y: 25)
            .opacity(showControls ? 1 : 0)
            .animation(.default, value: showControls)
    }

    private var Divider: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.gray.opacity(0.2))
    }

    private var Title: some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(isCompleted ? .gray : .black)
            .strikethrough(isCompleted)
            .layoutPriority(1)
    }

    private func Subtitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 15))
            .foregroundStyle(.gray.opacity(0.8))
    }

    @ViewBuilder
    private var Deadline: some View {
        HStack(spacing: 6) {
            Image(systemName: "clock")
                .font(.system(size: 14))
                .foregroundStyle(.blue)
            if let deadline {
                Text(deadline)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.blue)
            }
            else {
                Text("No deadline")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        NodeView(
            title: "Design System",
            description: "Create a comprehensive design",
            isCompleted: true,
            deadline: "Today, 14:30",
            isSelected: true,
            showControls: true,
            onTaskTapCompleted: {},
            onDeleteTapped: {}
        )

        NodeView(
            title: "User Authentication Flow",
            description: "Implement secure login and registration with biometric authentication support",
            isCompleted: false,
            deadline: "Tomorrow",
            isSelected: false,
            showControls: false,
            onTaskTapCompleted: {},
            onDeleteTapped: {}
        )
        
        NodeView(
            title: "Quick Task",
            description: nil,
            isCompleted: false,
            deadline: nil,
            isSelected: false,
            showControls: false,
            onTaskTapCompleted: {},
            onDeleteTapped: {}
        )
    }
    .padding()
    .background(Color(.systemGray6))
}

#Preview {
    NodeView(
        title: "User",
        description: "Implement ",
        isCompleted: false,
        deadline: "Tomorrow",
        isSelected: false,
        showControls: false,
        onTaskTapCompleted: {},
        onDeleteTapped: {}
    )
}
