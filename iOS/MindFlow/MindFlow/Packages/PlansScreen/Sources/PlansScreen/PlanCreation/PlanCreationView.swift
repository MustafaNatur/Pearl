//
//  PlanCreationView.swift
//  PlanCreation
//
//  Created by Mustafa on 01.07.2025.
//

import SwiftUI
import SharedModels
import UIToolBox

struct PlanCreationView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Form state
    @State private var title = ""
    @State private var selectedColor = "#007AFF"
    @State private var startDate = Date()
    @State private var hasDeadline = false
    @State private var nextDeadlineDate = Date()

    // UI state
    @State private var showingColorPicker = false
    @State private var isFormValid = false
    
    // Predefined colors
    private let predefinedColors = [
        "#007AFF", "#FF3B30", "#34C759", "#FF9500",
        "#AF52DE", "#FF2D92", "#5AC8FA", "#FFCC00",
        "#8E8E93", "#32D74B", "#BF5AF2", "#FF6482"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 36) {
                Header
                CreationForm
            }
            .padding(.horizontal, 24)
            .padding(.top, 36)
        }
        .onScrollPhaseChange { oldPhase, newPhase in
            if newPhase == .interacting {
                hideKeyboard()
            }
        }
        .safeAreaInset(edge: .bottom) {
            CreateButton
        }
        .onChange(of: title) { validateForm() }
    }

    private var CreationForm: some View {
        FormSections
            .onTapGesture(perform: hideKeyboard)
    }

    private var Header: some View {
        Text("New plan")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
    }

    private var FormSections: some View {
        VStack(spacing: 28) {
            TitleSection
            ColorSection
            TimelineSection
        }
    }
    
    private var CreateButton: some View {
        Button(action: createPlan) {
            Text("Create Plan")
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
    
    private var TitleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Title")
            TitleTextField
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

    private var ColorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Color")
            ColorGrid
        }
    }
    
    private var ColorGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 16) {
            ForEach(predefinedColors, id: \.self) { color in
                ColorSelectionButton(
                    color: color,
                    isSelected: selectedColor == color
                ) {
                    selectedColor = color
                }
            }
        }
        .padding(.horizontal, 8)
    }
    
    private var TimelineSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(title: "Timeline")
            TimelineContent
        }
        .animation(.easeInOut(duration: 0.3), value: hasDeadline)
    }
    
    private var TimelineContent: some View {
        VStack(spacing: 16) {
            StartDateCard
            DeadlineCard
        }
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

    private func SectionHeader(title: String) -> some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.primary)
    }

    private func validateForm() {
        isFormValid = !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func createPlan() {
        // TODO: Implement plan creation logic
        // This would typically invoke calling a service or passing data back to parent
        print("Creating plan with title: \(title)")
        dismiss()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct ColorSelectionButton: View {
    let color: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Circle()
            .fill(Color(hex: color))
            .frame(width: 40, height: 40)
            .onTapGesture(perform: action)
            .overlay(
                Circle()
                    .strokeBorder(.white, lineWidth: isSelected ? 3 : 0)
            )
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .shadow(color: Color(hex: color).opacity(0.3), radius: isSelected ? 4 : 0)
            .animation(.easeIn, value: isSelected)
    }
}

#Preview {
    PlanCreationView()
}
