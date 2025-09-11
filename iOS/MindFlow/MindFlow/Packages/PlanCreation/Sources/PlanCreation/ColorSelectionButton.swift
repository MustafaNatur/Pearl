//
//  ColorSelectionButton.swift
//  PlanCreation
//
//  Created by Mustafa on 02.07.2025.
//
import SwiftUI
import UIToolBox

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
