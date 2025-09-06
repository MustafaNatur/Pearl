import SwiftUI
import SharedModels
import PlanRepository

@Observable
class MindMapViewModel {
    enum Mode {
        case connection
        case edit
        case view
    }

    var mindMap: MindMap?
    var currentMode: Mode = .view

    private let mindMapId: String
    private let mindMapRepository: MindMapRepository
    private var selectedNodesForConnection: [Node] = []

    init(mindMapId: String, mindMapRepository: MindMapRepository = RepositoryImpl()) {
        self.mindMapId = mindMapId
        self.mindMapRepository = mindMapRepository
    }

    func onAppear() {
        currentMode = .view
        mindMap = try? mindMapRepository.fetchMindMap(mindMapId)
    }

    func createNode(_ node: Node) {
        currentMode = .view
        mindMap?.nodes.append(node)
    }

    func toggleMode(to mode: Mode) {
        guard currentMode != mode else {
            currentMode = .view
            return
        }
        currentMode = mode
    }

    func onTaskTapCompleted(_ node: Node) {
        if let index = mindMap?.nodes.firstIndex(where: { $0.id == node.id }) {
            mindMap?.nodes[index].isCompleted.toggle()
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
    
    func deleteNode(_ node: Node) {
        // Remove the node
        mindMap?.nodes.removeAll { $0.id == node.id }
        
        // Remove all connections that involve this node
        mindMap?.connections.removeAll { connection in
            connection.fromNodeId == node.id || connection.toNodeId == node.id
        }
    }

    func saveChanges() {
        guard let mindMap else {
            return
        }
        currentMode = .view
        try? mindMapRepository.updateMindMap(by: mindMapId, mindMap: mindMap)
    }
}
