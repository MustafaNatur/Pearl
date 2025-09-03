//
//  File.swift
//  PlanRepository
//
//  Created by Mustafa on 05.07.2025.
//

import Foundation
import SharedModels
import SwiftData
import CoreGraphics

// read one more time https://medium.com/@samhastingsis/use-swiftdata-like-a-boss-92c05cba73bf
// https://medium.com/@gauravharkhanxi01/designing-efficient-local-first-architectures-with-swiftdata-cc74048526f2
// https://medium.com/@darrenthiores/the-ultimate-guide-to-swiftdata-in-mvvm-achieves-separation-of-concerns-12305f9e82d1

public final class PlanRepositoryImpl: PlanRepository {
    enum PlanError: Error {
        case planNorFound
    }

    let modelContext: ModelContext?

    public init(modelContext: ModelContext? = SwiftDataContextManager.shared.context) {
        self.modelContext = modelContext
    }

    public func fetchPlans() throws -> [Plan] {
        let descriptor = FetchDescriptor<PlanScheme>()
        return try modelContext?.fetch(descriptor).map(\.plan) ?? []
    }

    public func savePlan(_ plan: Plan) throws {
        modelContext?.insert(plan.planScheme)
        try modelContext?.save()
    }

    public func deletePlan(_ plan: Plan) throws {
        let id = plan.id
        let predicate = #Predicate<PlanScheme> { $0.identifier == id }
        let descriptor = FetchDescriptor<PlanScheme>(predicate: predicate)

        guard let planScheme = try modelContext?.fetch(descriptor).first else {
            throw PlanError.planNorFound
        }

        modelContext?.delete(planScheme)

        try modelContext?.save()
    }

    public func updatePlan(_ plan: Plan) throws {
        let id = plan.id
        let predicate = #Predicate<PlanScheme> { $0.identifier == id }
        let descriptor = FetchDescriptor<PlanScheme>(predicate: predicate)

        guard let planScheme = try modelContext?.fetch(descriptor).first else {
            throw PlanError.planNorFound
        }

        planScheme.title = plan.title
        planScheme.overallStepsCount = plan.overallStepsCount
        planScheme.finishedStepsCount = plan.finishedStepsCount
        planScheme.color = plan.color
        planScheme.startDate = plan.startDate
        planScheme.nextDeadlineDate = plan.nextDeadlineDate
        planScheme.mindMap = plan.mindMap.mindMapScheme

        try modelContext?.save()
    }
}

// MARK: - Conversion Extensions
fileprivate extension Plan {
    var planScheme: PlanScheme {
        PlanScheme(
            identifier: id,
            title: title,
            overallStepsCount: overallStepsCount,
            finishedStepsCount: finishedStepsCount,
            color: color,
            startDate: startDate,
            nextDeadlineDate: nextDeadlineDate,
            mindMap: mindMap.mindMapScheme
        )
    }
}

fileprivate extension PlanScheme {
    var plan: Plan {
        Plan(
            id: identifier,
            title: title,
            overallStepsCount: overallStepsCount,
            finishedStepsCount: finishedStepsCount,
            color: color,
            startDate: startDate,
            nextDeadlineDate: nextDeadlineDate,
            mindMap: mindMap.mindMap
        )
    }
}

fileprivate extension MindMap {
    var mindMapScheme: MindMapScheme {
        MindMapScheme(
            nodes: nodes.map(\.nodeScheme),
            connections: connections.map(\.connectionScheme)
        )
    }
}

fileprivate extension MindMapScheme {
    var mindMap: MindMap {
        MindMap(
            nodes: nodes.map(\.node),
            connections: connections.map(\.connection)
        )
    }
}

// MARK: - Node Conversion Extensions
fileprivate extension Node {
    var nodeScheme: NodeScheme {
        NodeScheme(
            identifier: id.uuidString,
            isCompleted: isCompleted,
            positionX: position.x,
            positionY: position.y,
            task: task.taskScheme
        )
    }
}

fileprivate extension NodeScheme {
    var node: Node {
        Node(
            isCompleted: isCompleted,
            position: CGPoint(x: positionX, y: positionY),
            task: task.task
        )
    }
}

fileprivate extension Connection {
    var connectionScheme: ConnectionScheme {
        ConnectionScheme(
            identifier: id.uuidString,
            fromNodeId: from.uuidString,
            toNodeId: to.uuidString
        )
    }
}

fileprivate extension ConnectionScheme {
    var connection: Connection {
        Connection(
            from: UUID(uuidString: fromNodeId) ?? UUID(),
            to: UUID(uuidString: toNodeId) ?? UUID()
        )
    }
}

fileprivate extension Task {
    var taskScheme: TaskScheme {
        TaskScheme(
            title: title,
            note: note,
            deadline: deadline
        )
    }
}

fileprivate extension TaskScheme {
    var task: Task {
        Task(
            title: title,
            note: note,
            deadline: deadline
        )
    }
}
