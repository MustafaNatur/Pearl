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
            nextDeadlineDate: deadlineDate,
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
            nextDeadlineDate: deadlineDate,
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
            positionX: position.x,
            positionY: position.y,
            task: task.toTaskScheme
        )
    }
}

extension NodeScheme {
    var toNode: Node {
        let node = Node(
            id: identifier,
            task: task.toTask,
            position: CGPoint(x: positionX, y: positionY),
            scale: 1
        )
        // Note: We can't set the id directly since it's let, but the identifier is preserved in the scheme
        return node
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
            dateDeadline: dateDeadline,
            timeDeadline: timeDeadline,
            isCompleted: isCompleted
        )
    }
}

extension TaskScheme {
    var toTask: Task {
        Task(
            title: title,
            note: note,
            dateDeadline: dateDeadline,
            timeDeadline: timeDeadline,
            isCompleted: isCompleted
        )
    }
}
