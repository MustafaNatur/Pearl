import SwiftUI
import SharedModels
import UIToolBox
import TaskScreen

struct MindMapView: View {
    @Binding var lastScale: CGFloat
    @Binding var lastOffset: CGPoint
    let mindMap: MindMap
    let currentMode: MindMapViewModel.Mode
    let nodeIsSelected: (Node) -> Bool
    let onNodeTapCompleted: (Node) -> Void
    let updateNodePosition: (Node, CGPoint) -> Void
    let selectNodeForConnection: (Node) -> Void
    let toggleModeAction: (MindMapViewModel.Mode) -> Void
    let deleteConnection: (Connection) -> Void
    let navigateToNodeScreen: (Node) -> Void
    let navigateToNodeDeleteAlert: (Node) -> Void
    let navigateToCreationNodeSheet: () -> Void

    var body: some View {
        Canvas
            .overlay(alignment: .bottom) {
                ToolBar
            }
    }

    private var Canvas: some View {
        MoveAndScaleLayout(previousZoomScale: $lastScale, previousOffset: $lastOffset) {
            MindMap
        } background: {
            Background
        }
    }

    private var Background: some View {
        DotGridBackground()
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
                ConnectionView(
                    from: fromNode.position,
                    to: toNode.position,
                    showDeleteButton: currentMode == .edit,
                    onDeleteTapped: {
                        deleteConnection(connection)
                    }
                )
            }
        }
    }

    private var Nodes: some View {
        ForEach(mindMap.nodes) { node in
            NodeView(
                title: node.task.title,
                description: node.task.note,
                isCompleted: node.task.isCompleted,
                deadline: node.task.deadlineString,
                isSelected: nodeIsSelected(node),
                showControls: currentMode == .edit,
                onTaskTapCompleted: {
                    onNodeTapCompleted(node)
                },
                onDeleteTapped: {
                    navigateToNodeDeleteAlert(node)
                }
            )
            .shake(when: isInEditMode, intensity: 1)
            .position(node.position)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let newPosition = CGPoint(x: gesture.location.x, y: gesture.location.y)
                        updateNodePosition(node, newPosition)
                    }
            )
            .onTapGesture {
                switch currentMode {
                case .connection: selectNodeForConnection(node)
                case .view: navigateToNodeScreen(node)
                case .edit: break
                }
            }
            .animation(.easeInOut(duration: 0.1), value: node.position)
        }
    }

    private var ToolBar: some View {
        HStack(spacing: 16) {
            AddItemButton
            ConnectionModeButton
            EditModeButton
        }
        .padding()
        .background(Color.white)
        .clipShape(.capsule)
        .shadow(radius: 6)
    }

    private var EditModeButton: some View {
        Button {
            toggleModeAction(.edit)
        } label: {
            Image(systemName: isInEditMode ? "pencil.circle.fill" : "pencil.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(isInEditMode ? .orange : .gray)
        }
    }

    private var AddItemButton: some View {
        Button(action: navigateToCreationNodeSheet) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
        }
    }

    private var ConnectionModeButton: some View {
        Button {
            toggleModeAction(.connection)
        } label: {
            Image(systemName: isInConnectionMode ? "link.circle.fill" : "link.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(isInConnectionMode ? .green : .gray)
        }
    }

    private var isInConnectionMode: Bool {
        currentMode == .connection
    }

    private var isInEditMode: Bool {
        currentMode == .edit
    }
}
