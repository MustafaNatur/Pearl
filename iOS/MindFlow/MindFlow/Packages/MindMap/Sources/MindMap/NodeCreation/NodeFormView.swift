import SwiftUI
import SharedModels

struct NodeFormView: View {
    private let onTapAction: (Node) -> Void
    @State private var title = ""
    @State private var description = ""
    @State private var deadline = Date()
    @State private var hasDate = false
    @State private var hasTime = false
    @State private var isFormValid = false
    @Environment(\.dismiss) private var dismiss

    init(
        onTapAction: @escaping (Node) -> Void
    ) {
        self.onTapAction = onTapAction
    }

    var body: some View {
        Form {
            TitleSection
            DeadlineSection
        }
        .onScrollPhaseChange { oldPhase, newPhase in
            if newPhase == .interacting {
                hideKeyboard()
            }
        }
        .scrollContentBackground(.hidden)
        .background(.white)
        .onChange(of: title, validateForm)
        .onTapGesture(perform: hideKeyboard)
        .safeAreaInset(edge: .bottom) { ActionButton }
        .animation(.default, value: hasDate)
        .animation(.default, value: hasTime)
    }
    
    private var Header: some View {
        Text("New task")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
    }

    private var TitleSection: some View {
        Section {
            TextField("Title", text: $title)
                .font(.system(size: 24, weight: .medium))

            TextField("Description", text: $description, axis: .vertical)
                .font(.system(size: 20))
                .foregroundColor(.secondary)
                .lineLimit(3...6)
        } header: {
            Header
                .padding(.top, 50)
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .listRowBackground(Color(.systemGray6))
    }
    
    private var DeadlineSection: some View {
        Section {
            ExpandableDatePicker
            ExpandableTimePicker
        } header: {
            Text("Deadline")
        }
        .listRowBackground(Color(.systemGray6))
    }

    @ViewBuilder
    private var ExpandableDatePicker: some View {
        Toggle(isOn: $hasDate) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                    .frame(width: 28)
                Text("Date")
            }
        }
        .onTapGesture(perform: hideKeyboard)
        .toggleStyle(SwitchToggleStyle(tint: .blue))
        
        if hasDate {
            DatePicker("", selection: $deadline, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .labelsHidden()
        }
    }

    @ViewBuilder
    private var ExpandableTimePicker: some View {
        Toggle(isOn: $hasTime) {
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.blue)
                    .frame(width: 28)
                Text("Time")
            }
        }
        .onTapGesture(perform: hideKeyboard)
        .toggleStyle(SwitchToggleStyle(tint: .blue))
        
        if hasTime {
            DatePicker("", selection: $deadline, displayedComponents: [.hourAndMinute])
                .datePickerStyle(.wheel)
                .labelsHidden()
        }
    }

    private var ActionButton: some View {
        Button(action: onTap) {
            Text("Create task")
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

    private var hasDeadline: Bool {
        hasDate || hasTime
    }

    private var resultNode: Node {
        Node(
            isCompleted: false,
            title: title,
            description: description,
            deadLine: hasDeadline ? deadline : nil,
            position: CGPoint(x: 200, y: 200)
        )
    }

    private func validateForm() {
        isFormValid = !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func onTap() {
        onTapAction(resultNode)
        dismiss()
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
        onTapAction: { _ in }
    )
}

#Preview {
    NodeFormView(
        onTapAction: { _ in }
    )
}
