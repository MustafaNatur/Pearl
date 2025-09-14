import SwiftUI
import SharedModels
import UIToolBox

public struct TaskScreenView: View {
    let task: Task
    let onEdit: (Task) -> Void
    let onDelete: () -> Void

    @State private var title = ""
    @State private var description = ""
    @State private var dateDeadline = Date()
    @State private var timeDeadline = Date()
    @State private var hasDate = false
    @State private var hasTime = false
    @State private var isCompleted = false
    @State private var isFormValid = false
    @State private var showDeleteAlert = false

    public init(
        task: Task,
        onEdit: @escaping (Task) -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.task = task
        self.onEdit = onEdit
        self.onDelete = onDelete
    }

    public var body: some View {
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
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            self.title = task.title
            self.description = task.note ?? ""
            self.dateDeadline = task.dateDeadline ?? .now
            self.timeDeadline = task.timeDeadline ?? .now
            self.hasDate = task.dateDeadline != nil
            self.hasTime = task.timeDeadline != nil
            self.isCompleted = task.isCompleted
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    onEdit(editedTask)
                } label: {
                    Label("Confirm", systemImage: "checkmark")
                }
                .disabled(task == editedTask || isFormValid == false)
            }

            ToolbarItem(placement: .destructiveAction) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .deleteConfirmationAlert(
            isPresented: $showDeleteAlert,
            title: "Delete Task",
            message: "Are you sure you want to delete this task?",
            onConfirm: onDelete
        )
    }


    private var TitleSection: some View {
        Section {
            HStack {
                TextField("Title", text: $title)
                    .font(.system(size: 24, weight: .medium))
                Spacer()
                CheckButton(isCompleted: isCompleted) {
                    isCompleted.toggle()
                }
            }

            TextField("Description", text: $description, axis: .vertical)
                .font(.system(size: 20))
                .foregroundColor(.secondary)
                .lineLimit(3...6)
        } header: {
            Text("Task")
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
        .toggleStyle(SwitchToggleStyle(tint: .blue))
    }

    private var editedTask: Task {
        Task(
            title: title,
            note: description.isEmpty ? nil : description,
            dateDeadline: hasDate ? dateDeadline : nil,
            timeDeadline: hasTime ? timeDeadline : nil,
            isCompleted: isCompleted // do not react on isCompleted changes
        )
    }

    private func validateForm() {
        isFormValid = !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
    NavigationStack {
        TaskScreenView(
            task: Task(
                title: "Learn SwiftUI",
                note: "Complete the SwiftUI tutorial and build a sample app",
                dateDeadline: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
                timeDeadline: Calendar.current.date(byAdding: .hour, value: 9, to: Date()),
                isCompleted: false
            ),
            onEdit: { _ in },
            onDelete: { }
        )
    }
}
