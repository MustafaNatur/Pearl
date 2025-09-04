import SwiftUI
import SharedModels

struct MindMapView: View {
    @State var creationSheetIsPresented: Bool = false
    let mindMap: MindMap
    let isInConnectionMode: Bool
    let nodeIsSelected: (Node) -> Bool
    let updateNodePosition: (Node, CGPoint) -> Void
    let selectNodeForConnection: (Node) -> Void
    let addItemAction: (Node) -> Void
    let toggleConnectionModeAction: () -> Void
    let onTaskTapCompleted: (Node) -> Void

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
            NodeFormView(onTapAction: addItemAction)
        }
    }

    private var Background: some View {
        Color.gray.opacity(0.1)
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
            if let fromNode = mindMap.nodes.first(where: { $0.id == connection.fromNodeId }),
               let toNode = mindMap.nodes.first(where: { $0.id == connection.toNodeId }) {
                ConnectionView(from: fromNode.position, to: toNode.position)
            }
        }
    }

    private var Nodes: some View {
        ForEach(mindMap.nodes) { node in
            NodeView(
                title: node.task.title,
                description: node.task.note,
                isCompleted: node.isCompleted,
                deadline: node.task.deadline.map { $0.formattedString },
                isSelected: nodeIsSelected(node),
                onTaskTapCompleted: { onTaskTapCompleted(node) }
            )
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

fileprivate extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "E, d MMMM, HH:mm"
        let formattedDate = formatter.string(from: self)
        return formattedDate
    }
}
