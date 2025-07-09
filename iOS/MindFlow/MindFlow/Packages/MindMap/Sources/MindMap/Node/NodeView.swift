import SwiftUI

struct NodeView: View {
    @ObservedObject var viewModel: MindMapViewModel
    @State var node: Node
    @State private var isDragging = false
    @State private var showingEdit = false
    @State private var editedTitle: String = ""
    @State private var showingColorPicker = false
    
    var body: some View {
        Text(node.title)
            .font(.headline)
            .padding()
            .background(node.color)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            .position(node.position)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(viewModel.isNodeSelected(node) ? Color.yellow : Color.clear, lineWidth: 3)
            )
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.isDragging = true
                        // Update position locally to reduce ViewModel updates during drag
                        let newPosition = CGPoint(x: gesture.location.x, y: gesture.location.y)
                        node.position = newPosition
                        // Update the node in ViewModel for connections to update
                        viewModel.updateNode(node)
                    }
                    .onEnded { _ in
                        self.isDragging = false
                    }
            )
            .onTapGesture(count: viewModel.connectionMode ? 1 : 2) {
                if viewModel.connectionMode {
                    viewModel.selectNodeForConnection(node)
                }
            }
            .onTapGesture(count: 2) {
                if !viewModel.connectionMode {
                    self.editedTitle = node.title
                    self.showingEdit = true
                }
            }
            .onLongPressGesture {
                self.showingColorPicker = true
            }
            .sheet(isPresented: $showingEdit) {
                EditNodeView(viewModel: viewModel, node: node, isPresented: $showingEdit, editedTitle: $editedTitle)
            }
            .actionSheet(isPresented: $showingColorPicker) {
                ActionSheet(title: Text("Select Node Color"), buttons: [
                    .default(Text("Orange")) { changeColor(to: Color.orange) },
                    .default(Text("Red")) { changeColor(to: Color.red) },
                    .default(Text("Blue")) { changeColor(to: Color.blue) },
                    .default(Text("Green")) { changeColor(to: Color.green) },
                    .cancel()
                ])
            }
            .animation(.easeInOut(duration: 0.1), value: node.position) // Faster animation for smoother movement
    }
    
    func changeColor(to color: Color) {
        node.color = color
        viewModel.updateNode(node)
    }
}
