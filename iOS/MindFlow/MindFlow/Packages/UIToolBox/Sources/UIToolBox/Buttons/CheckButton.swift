//
//  SwiftUIView.swift
//  UIToolBox
//
//  Created by Mustafa on 09.09.2025.
//

import SwiftUI

public struct CheckButton: View {
    private let isCompleted: Bool
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let onTap: () -> Void

    public init(isCompleted: Bool, onTap: @escaping () -> Void) {
        self.isCompleted = isCompleted
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: {
            impactFeedback.prepare()
            onTap()
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
        .buttonStyle(.plain)
    }
}

#Preview {
    CheckButton(isCompleted: true) {}
}
