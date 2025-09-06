import SwiftUI
import SharedModels
import UIToolBox

struct MindMapView: View {
    @State var creationSheetIsPresented: Bool = false
    @State private var nodeToDelete: Node?
    @State private var showDeleteAlert: Bool = false
    
    let mindMap: MindMap
    let currentMode: MindMapViewModel.Mode
    let nodeIsSelected: (Node) -> Bool
    let updateNodePosition: (Node, CGPoint) -> Void
    let selectNodeForConnection: (Node) -> Void
    let addItemAction: (Node) -> Void
    let toggleModeAction: (MindMapViewModel.Mode) -> Void
    let onTaskTapCompleted: (Node) -> Void
    let onConnectionDeleteTapped: (Connection) -> Void
    let onNodeDeleteTapped: (Node) -> Void
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        MoveAndScaleLayout { scale, offset in
            ZStack {
                InfinitePatternBackground(scale: scale, offset: offset)
                ZStack {
                    Background // fixes bug with disappearing animation
                    MindMap
                }
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
        .alert("Delete Node", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if let node = nodeToDelete {
                    impactFeedback.impactOccurred()
                    withAnimation{onNodeDeleteTapped(node)}
                }
            }
        } message: {
            Text("Are you sure you want to delete this node?")
        }
    }

    private var Background: some View {
        Color.clear
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
                isCompleted: node.isCompleted,
                deadline: node.task.deadline.map { $0.formattedString },
                isSelected: nodeIsSelected(node),
                showControls: currentMode == .edit,
                onTaskTapCompleted: { onTaskTapCompleted(node) },
                onEditTapped: {},
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
                if isInConnectionMode {
                    selectNodeForConnection(node)
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

fileprivate extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "E, d MMMM, HH:mm"
        let formattedDate = formatter.string(from: self)
        return formattedDate
    }
}
