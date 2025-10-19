import SwiftUI

public struct DeleteButton: View {
    private let action: () -> Void
    private let size: CGFloat
    private let color: Color
    
    public init(
        size: CGFloat = 50,
        color: Color = .red,
        action: @escaping () -> Void
    ) {
        self.size = size
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: "trash")
                .frame(width: size, height: size)
                .foregroundColor(color)
                .glassEffect()
                .clipShape(.circle)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        DeleteButton(action: {})
        DeleteButton(size: 30, color: .pink, action: {})
        DeleteButton(size: 50, color: .red.opacity(0.8), action: {})
    }
    .padding()
}

