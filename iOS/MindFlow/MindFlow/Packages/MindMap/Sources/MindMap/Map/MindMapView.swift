import SwiftUI
import SharedModels
import UIToolBox
import TaskScreen

struct MindMapView: View {
    @State var creationSheetIsPresented: Bool = false
    @State private var nodeToDelete: Node?
    @State private var showDeleteAlert: Bool = false
    @State private var selectedNode: Node?
    @State private var navigateToTaskScreen: Bool = false
    
    let mindMap: MindMap
    let currentMode: MindMapViewModel.Mode
    let nodeIsSelected: (Node) -> Bool
    let updateNodePosition: (Node, CGPoint) -> Void
    let selectNodeForConnection: (Node) -> Void
    let addItemAction: (Node) -> Void
    let toggleModeAction: (MindMapViewModel.Mode) -> Void

    // TODO: move to TaskScreenViewModel
    let onTaskTapCompleted: (Node) -> Void
    let onTaskDeleteTapped: (_ nodeId: String) -> Void

    let onConnectionDeleteTapped: (Connection) -> Void
    let onNodeDeleteTapped: (_ nodeId: String) -> Void
    let onUpdateTask: (Task, String) -> Void // TODO: move to TaskScreenViewModel
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        Canvas
            .overlay(alignment: .bottom) {
                ToolBar
            }
            .sheet(isPresented: $creationSheetIsPresented) {
                NodeFormView(onTapAction: addItemAction)
            }
            .deleteConfirmationAlert(
                isPresented: $showDeleteAlert,
                title: "Delete Task",
                message: "Are you sure you want to delete this task?",
                onConfirm: {
                    if let node = nodeToDelete {
                        impactFeedback.impactOccurred()
                        withAnimation{onNodeDeleteTapped(node.id)}
                    }
                }
            )
            .navigationDestination(isPresented: $navigateToTaskScreen) {
                if let node = selectedNode {
                    TaskScreenView(
                        task: node.task,
                        onEdit: { updatedTask in
                            onUpdateTask(updatedTask, node.id)
                            navigateToTaskScreen = false
                        },
                        onDelete: {
                            onTaskDeleteTapped(node.id)
                            navigateToTaskScreen = false
                        }
                    )
                }
            }
    }

    private var Canvas: some View {
        MoveAndScaleLayout { scale, offset in
            ZStack {
                Background // fixes bug with disappearing animation
                    .onTapGesture {
                        toggleModeAction(.view)
                    }
                MindMap
                    .offset(offset.applying(.init(scaleX: 1/scale, y: 1/scale)))
                    .scaleEffect(scale)
            }
        }
    }

    private var Background: some View {
        Color.gray.opacity(0.1)
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
                ConnectionView(
                    from: fromNode.position,
                    to: toNode.position,
                    showDeleteButton: currentMode == .edit,
                    onDeleteTapped: { onConnectionDeleteTapped(connection) }
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
                onTaskTapCompleted: { onTaskTapCompleted(node) },
                onDeleteTapped: {
                    nodeToDelete = node
                    showDeleteAlert = true
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
                case .view: 
                    selectedNode = node
                    navigateToTaskScreen = true
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
            impactFeedback.impactOccurred()
            toggleModeAction(.edit)
        } label: {
            Image(systemName: isInEditMode ? "pencil.circle.fill" : "pencil.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(isInEditMode ? .orange : .gray)
        }
    }

    private var AddItemButton: some View {
        Button {
            impactFeedback.impactOccurred()
            creationSheetIsPresented = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
        }
    }

    private var ConnectionModeButton: some View {
        Button {
            impactFeedback.impactOccurred()
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
