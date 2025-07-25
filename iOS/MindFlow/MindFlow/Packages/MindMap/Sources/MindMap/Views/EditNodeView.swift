import SwiftUI

struct EditNodeView: View {
    var viewModel: MindMapViewModel
    var node: Node
    @Binding var isPresented: Bool
    @Binding var editedTitle: String
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Edit Node")
                    .font(.headline)
                
                TextField("Node Title", text: $editedTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    var updatedNode = node
                    updatedNode.title = editedTitle
                    viewModel.updateNode(updatedNode)
                    isPresented = false
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarItems(leading:
                Button("Cancel") {
                    isPresented = false
                }
            )
        }
    }
}
