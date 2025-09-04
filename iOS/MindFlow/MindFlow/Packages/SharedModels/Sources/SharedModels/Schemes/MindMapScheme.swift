//
//  MindMap.swift
//  SharedModels
//
//  Created by Mustafa on 01.09.2025.
//

import SwiftData

@Model
public final class MindMapScheme {
    @Attribute(.unique)
    public var identifier: String
    @Relationship(deleteRule: .cascade)
    public var nodes: [NodeScheme]
    @Relationship(deleteRule: .cascade)
    public var connections: [ConnectionScheme]

    public init(
        identifier: String,
        nodes: [NodeScheme],
        connections: [ConnectionScheme]
    ) {
        self.identifier = identifier
        self.nodes = nodes
        self.connections = connections
    }
}

extension MindMapScheme {
    nonisolated(unsafe) public static let mock = MindMapScheme(identifier: "1", nodes: [], connections: [])
}
