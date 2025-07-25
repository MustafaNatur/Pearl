import SwiftUI

struct MindMap {
    var nodes: [Node] = []
    var connections: [Connection] = []
}

@Observable
class MindMapViewModel {
    var mindMap = MindMap()

    // For connecting nodes
    var connectionMode: Bool = false
    var selectedNodesForConnection: [Node] = []
    
    // Functions to manage nodes and connections
    func addNode(title: String, position: CGPoint, color: Color = Color.orange) {
        let newNode = Node(id: UUID(), title: title, position: position, color: color)
        mindMap.nodes.append(newNode)
    }
    
    func toggleConnectionMode() {
        connectionMode.toggle()
        selectedNodesForConnection.removeAll()
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
}
