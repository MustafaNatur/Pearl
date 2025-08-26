import SwiftUI

struct MindMapView: View {
    @State var creationSheetIsPresented: Bool = false
    let mindMap: MindMap
    let isInConnectionMode: Bool
    let nodeIsSelected: (Node) -> Bool
    let updateNodePosition: (Node, CGPoint) -> Void
    let selectNodeForConnection: (Node) -> Void
    let addItemAction: (Node) -> Void
    let toggleConnectionModeAction: () -> Void

    var body: some View {
        MoveAndScaleLayout { scale, offset in
            ZStack {
                Background
                InfinitePatternBackground(scale: scale, offset: offset)
                MindMap
                    .offset(offset)
                    .scaleEffect(scale)
            }
        }
        .overlay(alignment: .bottom) {
            ToolBar
        }
        .sheet(isPresented: $creationSheetIsPresented) {
            NodeFormView(intention: .create, onTapAction: addItemAction)
        }
    }

    private var Background: some View {
        Color.white
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
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
            NodeView(title: node.title, subtitle: node.description, isSelected: nodeIsSelected(node))
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

    private var ToolBar: some View {
        HStack(spacing: 16) {
            AddItemButton
            ChangeModeButton
        }
        .padding()
        .background(Color.white)
        .clipShape(.capsule)
        .shadow(radius: 6)
    }

    private var AddItemButton: some View {
        Button(action: { creationSheetIsPresented = true }) {
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
