import SwiftUI

struct NodeView: View {
    @State var title: String
    @State var subtitle: String
    let color: Color
    let isSelected: Bool

    init(title: String, subtitle: String, color: Color, isSelected: Bool) {
        self._title = State(initialValue: title)
        self._subtitle = State(initialValue: subtitle)
        self.color = color
        self.isSelected = isSelected
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Title
            Divider
            Subtitle
        }
        .fixedSize(horizontal: true, vertical: false)
        .padding()
        .background(Color.white)
        .foregroundColor(.black)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.2), radius: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.yellow : Color.clear, lineWidth: 3)
        )
    }

    private var Divider: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.gray.opacity(0.4))
    }

    private var Title: some View {
        TextField("Title", text: $title)
            .font(.headline)
    }

    private var Subtitle: some View {
        TextField("Subtitle", text: $subtitle)
            .font(.subheadline)
            .foregroundStyle(.gray)
    }
}

#Preview {
    NodeView(title: "Title", subtitle: "Subtitle", color: .red, isSelected: false)
}
