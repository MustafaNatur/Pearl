import SwiftUI
import SharedModels

struct NodeFormView: View {
    private let onTapAction: (Node) -> Void
    @State private var title = ""
    @State private var description = ""
    @State private var dateDeadline = Date()
    @State private var timeDeadline = Date()
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
        HStack {
            if hasDate {
                DatePicker("", selection: $dateDeadline, displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            else {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                        .frame(width: 28)
                    Text("Date")
                }
            }
            Spacer()
            Toggle("", isOn: $hasDate)
        }
        .frame(height: 32)
        .onTapGesture(perform: hideKeyboard)
        .toggleStyle(SwitchToggleStyle(tint: .blue))
    }

    @ViewBuilder
    private var ExpandableTimePicker: some View {
        Toggle(isOn: $hasTime) {
            if hasTime {
                DatePicker("", selection: $timeDeadline, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            else {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                        .frame(width: 28)
                    Text("Time")
                }
            }
        }
        .frame(height: 32)
        .onTapGesture(perform: hideKeyboard)
        .toggleStyle(SwitchToggleStyle(tint: .blue))
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
            id: UUID().uuidString,
            task: Task(
                title: title,
                note: description.isEmpty ? nil : description,
                dateDeadline: hasDate ? dateDeadline : nil,
                timeDeadline: hasTime ? timeDeadline : nil,
                isCompleted: false
            ),
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
