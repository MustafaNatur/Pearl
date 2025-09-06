import SwiftUI

public struct EditButton: View {
    private let action: () -> Void
    private let size: CGFloat
    private let color: Color
    
    public init(
        size: CGFloat = 30,
        color: Color = .orange,
        action: @escaping () -> Void
    ) {
        self.size = size
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .frame(width: size, height: size)
                .foregroundColor(color)
                .background(Color.white)
                .clipShape(.circle)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        EditButton(action: {})
        EditButton(size: 30, color: .blue, action: {})
        EditButton(size: 50, color: .purple, action: {})
    }
    .padding()
}
