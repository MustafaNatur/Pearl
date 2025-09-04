//
//  Mapings.swift
//  PlanRepository
//
//  Created by Mustafa on 04.09.2025.
//

import Foundation
import SharedModels

extension Plan {
    var toPlanScheme: PlanScheme {
        PlanScheme(
            identifier: id,
            title: title,
            overallStepsCount: overallStepsCount,
            finishedStepsCount: finishedStepsCount,
            color: color,
            startDate: startDate,
            nextDeadlineDate: nextDeadlineDate,
            mindMapId: mindMapId
        )
    }
}

extension PlanScheme {
    var toPlan: Plan {
        Plan(
            id: identifier,
            title: title,
            overallStepsCount: overallStepsCount,
            finishedStepsCount: finishedStepsCount,
            color: color,
            startDate: startDate,
            nextDeadlineDate: nextDeadlineDate,
            mindMapId: mindMapId
        )
    }
}

extension MindMap {
    var toMindMapScheme: MindMapScheme {
        MindMapScheme(
            identifier: id,
            nodes: nodes.map(\.toNodeScheme),
            connections: connections.map(\.toConnectionScheme)
        )
    }
}

extension MindMapScheme {
    var toMindMap: MindMap {
        MindMap(
            id: identifier,
            nodes: nodes.map(\.toNode),
            connections: connections.map(\.toConnection)
        )
    }
}

// MARK: - Node Conversion Extensions
extension Node {
    var toNodeScheme: NodeScheme {
        NodeScheme(
            identifier: id,
            isCompleted: isCompleted,
            positionX: position.x,
            positionY: position.y,
            task: task.toTaskScheme
        )
    }
}

extension NodeScheme {
    var toNode: Node {
        Node(
            id: identifier,
            isCompleted: isCompleted,
            position: CGPoint(x: positionX, y: positionY),
            task: task.toTask
        )
    }
}

extension Connection {
    var toConnectionScheme: ConnectionScheme {
        ConnectionScheme(
            identifier: id,
            fromNodeId: fromNodeId,
            toNodeId: toNodeId
        )
    }
}

extension ConnectionScheme {
    var toConnection: Connection {
        Connection(
            id: identifier,
            fromNodeId: fromNodeId,
            toNodeId: toNodeId
        )
    }
}

extension Task {
    var toTaskScheme: TaskScheme {
        TaskScheme(
            title: title,
            note: note,
            deadline: deadline
        )
    }
}

extension TaskScheme {
    var toTask: Task {
        Task(
            title: title,
            note: note,
            deadline: deadline
        )
    }
}
