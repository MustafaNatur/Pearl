import SwiftUI
import SharedModels
import PlanRepository

@Observable
@MainActor
class MindMapViewModel {
    enum Mode {
        case connection
        case edit
        case view
    }

    var mindMap: MindMap?
    var currentMode: Mode = .view
    var creationSheetIsPresented: Bool = false
    var nodeToDelete: Node?
    var connectionToDelete: Connection?
    var nodeToNavigate: Node?
    var lastZoomScale: CGFloat = 1
    var lastOffset = CGPoint(
        x: (Constants.canvasSize.width - Device.screenWidth) / 2,
        y: (Constants.canvasSize.height - Device.screenHeight) / 2
    )

    private let mindMapId: String
    private let mindMapRepository: MindMapRepository
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private var selectedNodesForConnection: [Node] = []

    init(mindMapId: String, mindMapRepository: MindMapRepository = RepositoryImpl()) {
        self.mindMapId = mindMapId
        self.mindMapRepository = mindMapRepository
    }

    func onAppear() {
        currentMode = .view
        mindMap = try? mindMapRepository.fetchMindMap(mindMapId)
    }

    func navigateToCreationNodeSheet() {
        creationSheetIsPresented = true
    }

    func navigateToConnectionDeleteAlert(connection: Connection) {
        connectionToDelete = connection
    }

    func navigateToNodeScreen(node: Node) {
        nodeToNavigate = node
    }

    func navigateToNodeDeleteAlert(node: Node) {
        nodeToDelete = node
    }

    func createNode(_ node: Node) {
        currentMode = .view
        let position = CGPoint(
            x: (lastOffset.x + Device.screenWidth / 2) / lastZoomScale,
            y: (lastOffset.y + Device.screenHeight / 2) / lastZoomScale
        )
        let newNode = Node(
            id: node.id,
            task: node.task,
            position: position
        )
        mindMap?.nodes.append(newNode)
    }

    func goHome() {
        guard let mindMap, !mindMap.nodes.isEmpty else {
            return
        }
        
        // Find the bounding box of all nodes
        let positions = mindMap.nodes.map(\.position)
        let minX = positions.map(\.x).min() ?? 0
        let maxX = positions.map(\.x).max() ?? 0
        let minY = positions.map(\.y).min() ?? 0
        let maxY = positions.map(\.y).max() ?? 0
        
        // Calculate the center point of the mind map
        let centerX = (minX + maxX) / 2
        let centerY = (minY + maxY) / 2
        
        // Calculate the offset to center this point on screen
        let targetOffset = CGPoint(
            x: centerX * lastZoomScale - Device.screenWidth / 2,
            y: centerY * lastZoomScale - Device.screenHeight / 2
        )

        withAnimation {
            lastOffset = targetOffset
        }
    }

    func toggleMode(to mode: Mode) {
        impactFeedback.impactOccurred()
        selectedNodesForConnection.removeAll()
        
        guard currentMode != mode else {
            currentMode = .view
            return
        }

        currentMode = mode
    }

    func onNodeTapCompleted(_ node: Node) {
        if let index = mindMap?.nodes.firstIndex(where: { $0.id == node.id }) {
            mindMap?.nodes[index].task.isCompleted.toggle()
        }
    }

    func selectNodeForConnection(_ node: Node) {
        guard let lastChosenNode = selectedNodesForConnection.last else {
            selectedNodesForConnection.append(node)
            return
        }

        guard lastChosenNode != node else {
            return
        }

        let newConnection = Connection(
            id: UUID().uuidString,
            fromNodeId: lastChosenNode.id,
            toNodeId: node.id
        )

        guard mindMap?.connections.contains(newConnection) == false else {
            return
        }

        selectedNodesForConnection.append(node)
        mindMap?.connections.append(newConnection)
    }

    func isNodeSelected(_ node: Node) -> Bool {
        selectedNodesForConnection.contains(node)
    }

    func updateNode(_ node: Node) {
        if let index = mindMap?.nodes.firstIndex(where: { $0.id == node.id }) {
            mindMap?.nodes[index] = node
        }
    }

    func updateNodePosition(_ node: Node, newPosition: CGPoint) {
        if let index = mindMap?.nodes.firstIndex(where: { $0.id == node.id }) {
            mindMap?.nodes[index].position = newPosition
        }
    }
    
    func deleteConnection(_ connection: Connection) {
        mindMap?.connections.removeAll { $0.id == connection.id }
    }

    func deleteNode(_ nodeId: String) {
        impactFeedback.impactOccurred()
        mindMap?.nodes.removeAll { $0.id == nodeId }
        mindMap?.connections.removeAll { connection in
            connection.fromNodeId == nodeId || connection.toNodeId == nodeId
        }
        saveChanges()
    }

    func onConfirmDeleteNode() {
        if let nodeId = nodeToDelete?.id {
            withAnimation {
                deleteNode(nodeId)
            }
            nodeToDelete = nil
        }
    }

    func saveChanges() {
        guard let mindMap else {
            return
        }
        currentMode = .view
        try? mindMapRepository.updateMindMap(by: mindMapId, mindMap: mindMap)
    }

    // TODO: delete it from here, move to TaskScreenViewModel
    func onUpdateTask(_ newTask: Task, nodeId: String) {
        if let index = mindMap?.nodes.firstIndex(where: { $0.id == nodeId }) {
            mindMap?.nodes[index].task = newTask
            saveChanges()
        }
    }

    // TODO: delete it from here, move to TaskScreenViewModel
    func deleteTask(_ nodeId: String) {
        deleteNode(nodeId)
        saveChanges()
    }
}
