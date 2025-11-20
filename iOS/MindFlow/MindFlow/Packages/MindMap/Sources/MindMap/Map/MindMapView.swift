import SwiftUI
import SharedModels
import UIToolBox
import TaskScreen

struct MindMapView: View {
    @Binding var lastScale: CGFloat
    @Binding var lastOffset: CGPoint
    @State var isInDebugMode: Bool = false

    let mindMap: MindMap
    let currentMode: MindMapViewModel.Mode
    let nodeIsSelected: (Node) -> Bool
    let onNodeTapCompleted: (Node) -> Void
    let updateNodePosition: (Node, CGPoint, Bool) -> Void
    let selectNodeForConnection: (Node) -> Void
    let toggleModeAction: (MindMapViewModel.Mode) -> Void
    let goHomeAction: () -> Void
    let deleteConnection: (Connection) -> Void
    let navigateToNodeScreen: (Node) -> Void
    let navigateToNodeDeleteAlert: (Node) -> Void
    let navigateToCreationNodeSheet: () -> Void

    var body: some View {
        Canvas 
            .overlay(alignment: .bottom) {
                ToolBar
            }
            .overlay(alignment: .topLeading) {
                if isInDebugMode {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Debug Info")
                            .font(.headline)
                            .fontWeight(.bold)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("MindMap Bounds Size:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("Width: \(String(format: "%.1f", mindMap.bounds.width))")
                                .font(.caption)
                                .monospaced()
                            Text("Height: \(String(format: "%.1f", mindMap.bounds.height))")
                                .font(.caption)
                                .monospaced()
                            Text("OriginX: \(String(format: "%.1f", mindMap.bounds.origin.x))")
                                .font(.caption)
                                .monospaced()
                            Text("OriginY: \(String(format: "%.1f", mindMap.bounds.origin.y))")
                                .font(.caption)
                                .monospaced()
                        }
                    }
                    .padding(12)
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
                    .allowsHitTesting(false)
                }
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
            if isInDebugMode {
                // Green border showing mind map bounds
                Rectangle()
                    .stroke(Color.green, lineWidth: 3)
                    .frame(width: mindMap.bounds.width, height: mindMap.bounds.height)
                    .position(
                        x: mindMap.bounds.origin.x + mindMap.bounds.width / 2,
                        y: mindMap.bounds.origin.y + mindMap.bounds.height / 2
                    )
                Circle()
                    .fill((Color.green))
                    .frame(width: 25, height: 25)
                    .position(
                        x: mindMap.bounds.origin.x + mindMap.bounds.width / 2,
                        y: mindMap.bounds.origin.y + mindMap.bounds.height / 2
                    )
            }

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
                scale: node.scale,
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
                        updateNodePosition(node, newPosition, true)
                    }
                    .onEnded { gesture in
                        let newPosition = CGPoint(x: gesture.location.x, y: gesture.location.y)
                        updateNodePosition(node, newPosition, false)
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
            .animation(.easeInOut, value: node.scale)

        }
    }

    private var ToolBar: some View {
        HStack(spacing: 16) {
            AddItemButton
            ConnectionModeButton
            EditModeButton
            HomeButton
        }
        .padding()
        .background(Color.white)
        .clipShape(.capsule)
        .shadow(radius: 6)
    }

    private var HomeButton: some View {
        Button(action: goHomeAction){
            Image(systemName: "house.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
        }
        .onTapGesture(count: 5) {
            isInDebugMode.toggle()
        }
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
