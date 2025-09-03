import Foundation

public struct MindMap: Equatable, Sendable {
    public var nodes: [Node] = []
    public var connections: [Connection] = []

    public init(nodes: [Node], connections: [Connection]) {
        self.nodes = nodes
        self.connections = connections
    }
}

extension MindMap {
    @MainActor public static var empty = MindMap(nodes: [], connections: [])
}
