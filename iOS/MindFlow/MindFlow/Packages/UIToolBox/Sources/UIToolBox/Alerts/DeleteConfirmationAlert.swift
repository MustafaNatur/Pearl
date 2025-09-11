import SwiftUI

public struct DeleteConfirmationAlert {
    public static func show(
        title: String = "Delete Item",
        message: String = "Are you sure you want to delete this item?",
        isPresented: Binding<Bool>,
        onConfirm: @escaping @Sendable () -> Void
    ) -> some View {
        EmptyView()
            .alert(title, isPresented: isPresented) {
                Button("Cancel", role: .cancel) {
                    isPresented.wrappedValue = false
                }
                Button("Delete", role: .destructive) {
                    Task { @MainActor in
                        onConfirm()
                        isPresented.wrappedValue = false
                    }
                }
            } message: {
                Text(message)
            }
    }
}

public struct DeleteConfirmationModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let onConfirm: () -> Void
    
    public init(
        isPresented: Binding<Bool>,
        title: String = "Delete Item",
        message: String = "Are you sure you want to delete this item?",
        onConfirm: @escaping () -> Void
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.onConfirm = onConfirm
    }
    
    public func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                Button("Cancel", role: .cancel) {
                    isPresented = false
                }
                Button("Delete", role: .destructive) {
                    Task { @MainActor in
                        onConfirm()
                        isPresented = false
                    }
                }
            } message: {
                Text(message)
            }
    }
}

public extension View {
    func deleteConfirmationAlert(
        isPresented: Binding<Bool>,
        title: String = "Delete Item",
        message: String = "Are you sure you want to delete this item?",
        onConfirm: @escaping () -> Void
    ) -> some View {
        self.modifier(
            DeleteConfirmationModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                onConfirm: onConfirm
            )
        )
    }
}
