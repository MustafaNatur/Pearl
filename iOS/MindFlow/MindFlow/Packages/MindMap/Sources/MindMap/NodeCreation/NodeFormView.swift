//
//  SwiftUIView.swift
//  MindMap
//
//  Created by Mustafa on 26.08.2025.
//

import SwiftUI

struct NodeFormView: View {
    enum Intention {
        case create
        case edit(Node)
    }

    private let intention: Intention
    private let onTapAction: (Node) -> Void
    @State private var title = ""
    @State private var description = ""
    @State private var isCompleted = false
    @State private var deadline = Date()
    @State private var hasDeadline = false
    @State private var isFormValid = false
    @Environment(\.dismiss) private var dismiss

    init(
        intention: Intention,
        onTapAction: @escaping (Node) -> Void
    ) {
        self.intention = intention
        self.onTapAction = onTapAction
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                Header
                Form
            }
            .padding(.horizontal, 24)
        }
        .onScrollPhaseChange { oldPhase, newPhase in
            if newPhase == .interacting {
                hideKeyboard()
            }
        }
        .safeAreaInset(edge: .bottom) {
            ActionButton
        }
        .onChange(of: title) { validateForm() }
        .onTapGesture(perform: hideKeyboard)
        .onAppear {
            setupInitialState()
        }
    }

    private var Header: some View {
        Text(formTitle)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
            .padding(.top, 58)
    }

    private var Form: some View {
        VStack(spacing: 48) {
            TitleTextField
            TimelineContent
        }
    }

    private var ActionButton: some View {
        Button(action: onTap) {
            Text(actionButtonTitle)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .clipShape(.rect(cornerRadius: 12))
        }
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1.0 : 0.6)
        .animation(.easeInOut(duration: 0.2), value: isFormValid)
        .padding(.horizontal, 52)
        .padding(.vertical, 16)
    }

    private var actionButtonTitle: String {
        switch intention {
        case .create: "Create task"
        case .edit: "Save changes"
        }
    }

    private var TitleTextField: some View {
        VStack(spacing: 0) {
            TextField("Title", text: $title)
                .font(.body)
                .padding(.all, 14)
                .submitLabel(.next)
            
            Divider()
                .padding(.horizontal, 16)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $description)
                    .font(.body)
                    .frame(minHeight: 50)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .scrollContentBackground(.hidden)
                
                if description.isEmpty {
                    Text("Description")
                        .font(.body)
                        .foregroundColor(Color(.placeholderText))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
            }
        }
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 12))

    }

    private var TimelineContent: some View {
        DeadlineCard
            .animation(.easeInOut(duration: 0.3), value: hasDeadline)
    }

    private var DeadlineCard: some View {
        VStack(spacing: 0) {
            DeadlineToggle
            if hasDeadline {
                DeadlinePicker
            }
        }
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 12))
    }

    private var DeadlineToggle: some View {
        HStack {
            Text("Set Deadline")
                .font(.body)
                .fontWeight(.medium)
            Spacer()
            Toggle("", isOn: $hasDeadline)

        }
        .padding(.all, 14)
    }

    private var DeadlinePicker: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.horizontal, 16)

            HStack {
                Text("Deadline")
                    .font(.body)
                    .fontWeight(.medium)

                Spacer()

                DatePicker("", selection: $deadline, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    private var formTitle: String {
        switch intention {
        case .create: "New task"
        case .edit: "Edit task"
        }
    }

    private var resultNode: Node {
        switch intention {
        case .create:
                .init(
                    id: UUID(),
                    isCompleted: false,
                    title: title,
                    description: description,
                    deadLine: hasDeadline ? deadline : nil,
                    position: CGPoint(x: 200, y: 200)
                )
        case .edit(let node):
                .init(
                    id: node.id,
                    isCompleted: false,
                    title: title,
                    description: description,
                    deadLine: hasDeadline ? deadline : nil,
                    position: CGPoint(x: 200, y: 200)
                )
        }
    }

    private func validateForm() {
        isFormValid = !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func onTap() {
        onTapAction(resultNode)
        print("Creating plan with title: \(title)")
        dismiss()
    }

    private func setupInitialState() {
        guard case let .edit(node) = intention else { return }
        self.title = node.title
        self.description = node.description
        self.deadline = node.deadLine ?? Date()
        self.hasDeadline = node.deadLine == nil ? false : true
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    NodeFormView(
        intention: .create,
        onTapAction: { _ in }
    )
}

#Preview {
    NodeFormView(
        intention: .edit(.mock),
        onTapAction: { _ in }
    )
}
