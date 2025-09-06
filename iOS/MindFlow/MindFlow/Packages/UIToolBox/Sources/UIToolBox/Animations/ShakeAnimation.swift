import SwiftUI

// MARK: - Simple Shake Animation ViewModifier
public struct ShakeAnimation: ViewModifier {
    let isShaking: Bool
    let intensity: CGFloat
    @State private var rotation: CGFloat = 0
    
    public func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation))
            .onChange(of: isShaking) { _, shaking in
                if shaking {
                    startShaking()
                } else {
                    stopShaking()
                }
            }
    }
    
    private func startShaking() {
        // Start from negative to create symmetric shake
        rotation = -intensity
        
        withAnimation(
            .easeInOut(duration: 0.1)
            .repeatForever(autoreverses: true)
        ) {
            rotation = intensity
        }
    }
    
    private func stopShaking() {
        withAnimation(.easeInOut(duration: 0.1)) {
            rotation = 0
        }
    }
}

// MARK: - View Extension
public extension View {
    /// Applies a shake animation when condition is true
    func shake(when condition: Bool, intensity: CGFloat = 2.5) -> some View {
        self.modifier(
            ShakeAnimation(
                isShaking: condition,
                intensity: intensity
            )
        )
    }
}