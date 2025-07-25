import SwiftUI

struct AddNodeView: View {
    var viewModel: MindMapViewModel
    @Binding var isPresented: Bool
    @Binding var newNodeTitle: String
    @Binding var newNodeColor: Color
    
    @State private var position: CGPoint = CGPoint(x: 200, y: 300)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Add New Node")
                    .font(.headline)
                
                TextField("Node Title", text: $newNodeTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Color Picker Integration
                ColorPicker("Select Color", selection: $newNodeColor)
                    .padding(.horizontal)
                
                Button(action: {
                    if !newNodeTitle.trimmingCharacters(in: .whitespaces).isEmpty {
                        // For position, you might want to set it based on user interaction. Here, using a default.
                        viewModel.addNode(title: newNodeTitle, position: position, color: newNodeColor)
                        isPresented = false
                        newNodeTitle = ""
                        newNodeColor = .orange
                    }
                }) {
                    Text("Add Node")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarItems(leading:
                Button("Cancel") {
                    isPresented = false
                    newNodeTitle = ""
                    newNodeColor = .orange
                }
            )
        }
    }
}
