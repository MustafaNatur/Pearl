import SwiftUI

struct MindMapView: View {
    let mindMap: MindMap
    let isInConnectionMode: Bool
    let nodeIsSelected: (Node) -> Bool
    let updateNodePosition: (Node, CGPoint) -> Void
    let selectNodeForConnection: (Node) -> Void
    let addItemAction: () -> Void
    let toggleConnectionModeAction: () -> Void

    var body: some View {
        MoveAndScaleLayout { scale, offset in
            ZStack {
                Background
                    .edgesIgnoringSafeArea(.all)
                MindMap
                    .scaleEffect(scale)
                    .offset(offset)
            }
        }
        .overlay(alignment: .bottom) {
            ToolBar
        }
    }

    private var MindMap: some View {
        ZStack {
            Connections
            Nodes
        }
    }

    private var Connections: some View {
        ForEach(mindMap.connections) { connection in
            if let fromNode = mindMap.nodes.first(where: { $0.id == connection.from }),
               let toNode = mindMap.nodes.first(where: { $0.id == connection.to }) {
                ConnectionView(from: fromNode.position, to: toNode.position)
            }
        }
    }

    private var Nodes: some View {
        ForEach(mindMap.nodes) { node in
            NodeView(title: node.title, color: node.color, isSelected: nodeIsSelected(node))
                .position(node.position)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let newPosition = CGPoint(x: gesture.location.x, y: gesture.location.y)
                            updateNodePosition(node, newPosition)
                        }
                )
                .onTapGesture(count: isInConnectionMode ? 1 : 2) {
                    if isInConnectionMode {
                        selectNodeForConnection(node)
                    }
                }
                .animation(.easeInOut(duration: 0.1), value: node.position) // Faster animation for smoother movement
        }
    }

    private var Background: some View {
        LinearGradient(
            gradient:Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var ToolBar: some View {
        HStack(spacing: 16) {
            AddItemButton
            ChangeModeButton
        }
        .padding()
        .background(Color.white)
        .clipShape(.capsule)
    }

    private var AddItemButton: some View {
        Button(action: addItemAction) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
        }
    }

    private var ChangeModeButton: some View {
        Button(action: toggleConnectionModeAction) {
            Image(systemName: isInConnectionMode ? "link.circle.fill" : "link.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(isInConnectionMode ? .green : .gray)
        }
    }
}

//#Preview {
//    MindMapView(
//        mindMap: ,
//        isInConnectionMode: false,
//        addItemAction: {},
//        toggleConnectionModeAction: {}
//    )
//}
