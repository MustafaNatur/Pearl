//
//  File.swift
//  PlanRepository
//
//  Created by Mustafa on 01.09.2025.
//

import Foundation
import SwiftData

@Model
public final class NodeScheme {
    public var identifier: String
    public var isCompleted: Bool
    public var positionX: Double
    public var positionY: Double
    @Relationship(deleteRule: .cascade)
    public var task: TaskScheme

    public init(
        identifier: String,
        isCompleted: Bool = false,
        positionX: Double,
        positionY: Double,
        task: TaskScheme
    ) {
        self.identifier = identifier
        self.isCompleted = isCompleted
        self.positionX = positionX
        self.positionY = positionY
        self.task = task
    }
}


