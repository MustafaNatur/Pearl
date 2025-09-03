//
//  PlanCreationView.swift
//  PlanCreation
//
//  Created by Mustafa on 01.07.2025.
//

import SwiftUI
import SharedModels
import UIToolBox

public struct PlanFormView: View {
    public enum Intention {
        case create
        case edit(Plan)
    }

    private let onTapAction: (Plan) -> Void
    private let intention: Intention
    @State private var title = ""
    @State private var selectedColor = "#007AFF"
    @State private var startDate = Date()
    @State private var hasDeadline = false
    @State private var nextDeadlineDate = Date()
    @State private var isFormValid = false
    @Environment(\.dismiss) private var dismiss

    public init(
        intention: Intention,
        onTapAction: @escaping (Plan) -> Void
    ) {
        self.intention = intention
        self.onTapAction = onTapAction
    }

    public var body: some View {
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
            ColorGrid
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
                .background(Color(hex: selectedColor))
                .clipShape(.rect(cornerRadius: 12))
        }
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1.0 : 0.6)
        .animation(.easeInOut(duration: 0.2), value: isFormValid)
        .animation(.easeInOut(duration: 0.3), value: selectedColor)
        .padding(.horizontal, 52)
        .padding(.vertical, 16)
    }

    private var actionButtonTitle: String {
        switch intention {
        case .create: "Create Plan"
        case .edit: "Save changes"
        }
    }

    private var TitleTextField: some View {
        TextField("What do you want to achieve?", text: $title)
            .font(.body)
            .padding(.all, 16)
            .background(Color(.systemGray6))
            .clipShape(.rect(cornerRadius: 12))
            .submitLabel(.next)
    }
    
    private var ColorGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 16) {
            ForEach(predefinedColors, id: \.self) { color in
                ColorSelectionButton(
                    color: color,
                    isSelected: selectedColor == color
                ) {
                    // Add haptic feedback for color selection
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    
                    selectedColor = color
                }
            }
        }
        .padding(.horizontal, 8)
    }
    
    private var TimelineContent: some View {
        VStack(spacing: 16) {
            StartDateCard
            DeadlineCard
        }
        .animation(.easeInOut(duration: 0.3), value: hasDeadline)
    }
    
    private var StartDateCard: some View {
        HStack {
            Text("Start Date")
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            DatePicker("", selection: $startDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
        }
        .padding(.all, 14)
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 12))
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
                
                DatePicker("", selection: $nextDeadlineDate, 
                         in: startDate..., displayedComponents: .date)
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
        case .create: "New plan"
        case .edit: "Edit plan"
        }
    }

    private var resultPlan: Plan {
        switch intention {
        case .create:
                .init(
                    id: UUID().uuidString,
                    title: title,
                    overallStepsCount: 0,
                    finishedStepsCount: 0,
                    color: selectedColor,
                    startDate: startDate,
                    nextDeadlineDate: hasDeadline ? nextDeadlineDate : nil,
                    mindMap: .empty
                )
        case .edit(let oldPlan):
                .init(
                    id: oldPlan.id,
                    title: title,
                    overallStepsCount: oldPlan.overallStepsCount,
                    finishedStepsCount: oldPlan.finishedStepsCount,
                    color: selectedColor,
                    startDate: startDate,
                    nextDeadlineDate: hasDeadline ? nextDeadlineDate : nil,
                    mindMap: oldPlan.mindMap
                )
        }
    }

    private func validateForm() {
        isFormValid = !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func onTap() {
        onTapAction(resultPlan)
        print("Creating plan with title: \(title)")
        dismiss()
    }

    private func setupInitialState() {
        guard case let .edit(plan) = intention else { return }
        print(plan.title)
        self.title = plan.title
        self.selectedColor = plan.color
        self.startDate = plan.startDate
        self.hasDeadline = plan.nextDeadlineDate == nil ? false : true
        self.nextDeadlineDate = plan.nextDeadlineDate ?? Date()
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

private let predefinedColors = [
    "#007AFF", "#FF3B30", "#34C759", "#FF9500",
    "#AF52DE", "#FF2D92", "#5AC8FA", "#FFCC00",
    "#8E8E93", "#32D74B", "#BF5AF2", "#FF6482"
]

#Preview {
    PlanFormView(
        intention: .create,
        onTapAction: { _ in }
    )
}

#Preview {
    PlanFormView(
        intention: .edit(.mock),
        onTapAction: { _ in }
    )
}

