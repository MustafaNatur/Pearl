import SwiftUI

struct NodeView: View {
    let title: String
    let description: String
    let isCompleted: Bool
    let deadline: String?
    let isSelected: Bool
    let onTaskTapCompleted: () -> Void
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Title
                Spacer()
                CheckButton
            }
            Divider
            Subtitle
            Deadline
                .padding(.top, 20)
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
    }

    private var Divider: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.gray.opacity(0.4))
    }

    private var Title: some View {
        Text(title)
            .font(.headline)
    }

    private var Subtitle: some View {
        Text(description)
            .font(.subheadline)
            .foregroundStyle(.gray)
    }

    @ViewBuilder
    private var Deadline: some View {
        if let deadline {
            Text(deadline)
                .font(.body)
                .foregroundStyle(.gray)
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
                    .fill(isCompleted ? Color.green : Color.gray.opacity(0.4))
                    .frame(width: 24, height: 24)

                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(isCompleted ? 1 : 0)
            }
        }
    }
}

#Preview {
    NodeView(
        title: "Task name",
        description: "Task description",
        isCompleted: true,
        deadline: "Sa, 29 august 2020",
        isSelected: true,
        onTaskTapCompleted: {}
    )

    NodeView(
        title: "Task name",
        description: "Task description",
        isCompleted: false,
        deadline: nil,
        isSelected: false,
        onTaskTapCompleted: {}
    )
}
