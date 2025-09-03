import Foundation

public struct MindMap: Equatable {
    public var nodes: [Node] = []
    public var connections: [Connection] = []

    public init(nodes: [Node], connections: [Connection]) {
        self.nodes = nodes
        self.connections = connections
    }
}
