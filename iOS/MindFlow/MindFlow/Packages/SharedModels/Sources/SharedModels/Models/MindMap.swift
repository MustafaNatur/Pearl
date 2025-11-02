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
    public var bounds: CGRect {
        let positions = nodes.map(\.position)
        let minX = positions.map(\.x).min() ?? 0
        let maxX = positions.map(\.x).max() ?? 0
        let minY = positions.map(\.y).min() ?? 0
        let maxY = positions.map(\.y).max() ?? 0
        
        return CGRect(
            x: minX,
            y: minY,
            width: maxX - minX,
            height: maxY - minY
        )
    }
}

extension MindMap {
    @MainActor public static var empty = MindMap(id: "1", nodes: [], connections: [])
}
