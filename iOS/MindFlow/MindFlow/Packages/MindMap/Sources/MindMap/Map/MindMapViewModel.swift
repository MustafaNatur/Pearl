import SwiftUI
import SharedModels
import PlanRepository

@Observable
class MindMapViewModel {
    var connectionMode: Bool = false
    var mindMap: MindMap?

    private let mindMapId: String
    private let mindMapRepository: MindMapRepository
    private var selectedNodesForConnection: [Node] = []

    init(mindMapId: String, mindMapRepository: MindMapRepository = RepositoryImpl()) {
        self.mindMapId = mindMapId
        self.mindMapRepository = mindMapRepository
    }

    func onAppear() {
        mindMap = try? mindMapRepository.fetchMindMap(mindMapId)
    }

    func createNode(_ node: Node) {
        mindMap?.nodes.append(node)
    }

    func toggleConnectionMode() {
        connectionMode.toggle()
        selectedNodesForConnection.removeAll()
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

    func saveChanges() {
        guard let mindMap else {
            return
        }
        try? mindMapRepository.updateMindMap(by: mindMapId, mindMap: mindMap)
    }
}
