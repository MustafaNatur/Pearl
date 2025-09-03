//
//  Connection.swift
//  PlanRepository
//
//  Created by Mustafa on 01.09.2025.
//

import SwiftData

@Model
public final class ConnectionScheme {
    public var fromNodeId: String
    public var toNodeId: String

    public init(fromNodeId: String, toNodeId: String) {
        self.fromNodeId = fromNodeId
        self.toNodeId = toNodeId
    }
}
