import SwiftUI

struct AddNodeView: View {
    @State var newNodeTitle: String = ""
    @State var newNodeColor: Color = .red
    let createNodeAction: (String, Color) -> Void
    
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
                
                Button(action: createNode) {
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
                    newNodeTitle = ""
                    newNodeColor = .orange
                }
            )
        }
    }

    private func createNode() {
        createNodeAction(newNodeTitle, newNodeColor)
    }
}
