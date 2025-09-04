import Foundation

public struct MindMap: Equatable, Sendable {
    public let id: String
    public var nodes: [Node] = []
    public var connections: [Connection] = []

    public init(
        id: String,
        nodes: [Node],
        connections: [Connection]
    ) {
        self.id = id
        self.nodes = nodes
        self.connections = connections
    }
}

extension MindMap {
    @MainActor public static var empty = MindMap(id: "1", nodes: [], connections: [])
}
