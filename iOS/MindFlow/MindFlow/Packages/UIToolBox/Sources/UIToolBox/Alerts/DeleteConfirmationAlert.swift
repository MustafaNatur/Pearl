import SwiftUI

public struct DeleteConfirmationModifier<T: Hashable>: ViewModifier {
    let item: Binding<Optional<T>>
    let title: String
    let message: String
    let onConfirm: () -> Void
    
    public init(
        item: Binding<Optional<T>>,
        title: String = "Delete Item",
        message: String = "Are you sure you want to delete this item?",
        onConfirm: @escaping () -> Void
    ) {
        self.item = item
        self.title = title
        self.message = message
        self.onConfirm = onConfirm
    }

    var isPresented: Binding<Bool> {
        Binding {
            item.wrappedValue != nil
        } set: { _ in }
    }

    public func body(content: Content) -> some View {
        content
            .alert(title, isPresented: isPresented) {
                Button("Cancel", role: .cancel) {
                    item.wrappedValue = nil
                }
                Button("Delete", role: .destructive) {
                    onConfirm()
                    item.wrappedValue = nil
                }
            } message: {
                Text(message)
            }
    }
}

public extension View {
    func deleteConfirmationAlert(
        item: Binding<Optional<some Hashable>>,
        title: String = "Delete Item",
        message: String = "Are you sure you want to delete this item?",
        onConfirm: @escaping () -> Void
    ) -> some View {
        self.modifier(
            DeleteConfirmationModifier(
                item: item,
                title: title,
                message: message,
                onConfirm: onConfirm
            )
        )
    }
}
