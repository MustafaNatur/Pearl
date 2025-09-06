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
    let onEditTapped: () -> Void
    let onDeleteTapped: () -> Void
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Title
                Spacer()
                CheckButton
            }
            
            if let description {
                Divider
                Subtitle(description)
            }
            
            if deadline != nil {
                Deadline
                    .padding(.top, 8)
            }
        }
        .fixedSize(horizontal: true, vertical: false)
        .padding()
        .background(Color.white)
        .foregroundColor(.black)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? Color.yellow : Color.clear, lineWidth: 3)
        )
        .overlay(alignment: .bottom) {
            Controls
        }
    }

    private var Controls: some View {
        HStack {
            DeleteButton(action: onDeleteTapped)
                .offset(x: -15, y: 15)
            Spacer()
            EditButton(action: onEditTapped)
                .offset(x: 15, y: 15)
        }
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
            .lineLimit(2)
    }

    private func Subtitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 15))
            .foregroundStyle(.gray.opacity(0.8))
            .lineLimit(3)
    }

    @ViewBuilder
    private var Deadline: some View {
        if let deadline {
            HStack(spacing: 6) {
                Image(systemName: "clock")
                    .font(.system(size: 14))
                    .foregroundStyle(.blue)
                
                Text(deadline)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.blue)
            }
        }
    }

    private var CheckButton: some View {
        Button(action: {
            impactFeedback.prepare()
            onTaskTapCompleted()
            impactFeedback.impactOccurred()
        }) {
            ZStack {
                Circle()
                    .fill(isCompleted ? Color.green : Color.gray.opacity(0.15))
                    .frame(width: 26, height: 26)

                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(duration: 0.3), value: isCompleted)
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
            onEditTapped: {},
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
            onEditTapped: {},
            onDeleteTapped: {}
        )
        
        NodeView(
            title: "Quick Task",
            description: "",
            isCompleted: false,
            deadline: nil,
            isSelected: false,
            showControls: false,
            onTaskTapCompleted: {},
            onEditTapped: {},
            onDeleteTapped: {}
        )
    }
    .padding()
    .background(Color(.systemGray6))
}
