import SwiftUI
import SharedModels
import PlanRepository

@Observable
class MindMapViewModel {
    var connectionMode: Bool = false
    var mindMap: MindMap {
        didSet {
            sync(mindMap)
        }
    }

    private let sync: (MindMap) -> ()
    private var selectedNodesForConnection: [Node] = []

    init(mindMap: MindMap, sync: @escaping (MindMap) -> ()) {
        self.mindMap = mindMap
        self.sync = sync
    }

    func createNode(_ node: Node) {
        mindMap.nodes.append(node)
    }

    func toggleConnectionMode() {
        connectionMode.toggle()
        selectedNodesForConnection.removeAll()
    }

    func onTaskTapCompleted(_ node: Node) {
        if let index = mindMap.nodes.firstIndex(where: { $0.id == node.id }) {
            mindMap.nodes[index].isCompleted.toggle()
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

        let newConnection = Connection(from: lastChosenNode.id, to: node.id)

        guard mindMap.connections.contains(newConnection) == false else {
            return
        }

        selectedNodesForConnection.append(node)
        mindMap.connections.append(newConnection)
    }

    func isNodeSelected(_ node: Node) -> Bool {
        selectedNodesForConnection.contains(node)
    }

    func updateNode(_ node: Node) {
        if let index = mindMap.nodes.firstIndex(where: { $0.id == node.id }) {
            mindMap.nodes[index] = node
        }
    }

    func updateNodePosition(_ node: Node, newPosition: CGPoint) {
        if let index = mindMap.nodes.firstIndex(where: { $0.id == node.id }) {
            mindMap.nodes[index].position = newPosition
        }
    }
}
