//
//  MindMap.swift
//  SharedModels
//
//  Created by Mustafa on 01.09.2025.
//

import SwiftData

@Model
public final class MindMapScheme {
    @Relationship(deleteRule: .cascade) public var nodes: [NodeScheme]
    @Relationship(deleteRule: .cascade) public var connections: [ConnectionScheme]

    public init(nodes: [NodeScheme], connections: [ConnectionScheme]) {
        self.nodes = nodes
        self.connections = connections
    }
}

extension MindMapScheme {
    nonisolated(unsafe) public static let mock = MindMapScheme(nodes: [], connections: [])
}
