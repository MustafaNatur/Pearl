import SwiftUI

class MindMapViewModel: ObservableObject {
    @Published var nodes: [Node] = []
    @Published var connections: [Connection] = []
    
    // For connecting nodes
    @Published var connectionMode: Bool = false
    @Published var selectedNodesForConnection: [Node] = []
    
    // Functions to manage nodes and connections
    func addNode(title: String, position: CGPoint, color: Color = Color.orange) {
        let newNode = Node(id: UUID(), title: title, position: position, color: color)
        nodes.append(newNode)
    }
    
    func addConnection(from: UUID, to: UUID) {
        // Prevent duplicate or self connections
        guard from != to else { return }
        if !connections.contains(where: { ($0.from == from && $0.to == to) || ($0.from == to && $0.to == from) }) {
            let newConnection = Connection(id: UUID(), from: from, to: to)
            connections.append(newConnection)
        }
    }
    
    func toggleConnectionMode() {
        connectionMode.toggle()
        if !connectionMode {
            selectedNodesForConnection.removeAll()
        }
    }
    
    func selectNodeForConnection(_ node: Node) {
        if selectedNodesForConnection.contains(node) {
            selectedNodesForConnection.removeAll { $0.id == node.id }
        } else {
            selectedNodesForConnection.append(node)
            if selectedNodesForConnection.count == 2 {
                if let first = selectedNodesForConnection.first, let second = selectedNodesForConnection.last {
                    addConnection(from: first.id, to: second.id)
                }
                selectedNodesForConnection.removeAll()
            }
        }
    }
    
    func isNodeSelected(_ node: Node) -> Bool {
        selectedNodesForConnection.contains(node)
    }
    
    func updateNode(_ node: Node) {
        if let index = nodes.firstIndex(where: { $0.id == node.id }) {
            nodes[index] = node
        }
    }
}
