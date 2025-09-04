//
//  RepositoryImpl+Plan.swift
//  PlanRepository
//
//  Created by Mustafa on 04.09.2025.
//

import Foundation
import SharedModels
import SwiftData

extension RepositoryImpl {
    public func fetchPlans() throws -> [Plan] {
        let descriptor = FetchDescriptor<PlanScheme>()
        let plans = try modelContext?.fetch(descriptor).map(\.toPlan)
        return plans ?? []
    }

    public func createPlan(_ plan: Plan) throws {
        modelContext?.insert(plan.toPlanScheme)

        let emptyMindMap = MindMap(id: plan.mindMapId, nodes: [], connections: [])
        try createMindMap(emptyMindMap)
        try modelContext?.save()
    }

    public func deletePlan(_ plan: Plan) throws {
        let id = plan.id
        let predicate = #Predicate<PlanScheme> { $0.identifier == id }
        let descriptor = FetchDescriptor<PlanScheme>(predicate: predicate)

        guard let planScheme = try modelContext?.fetch(descriptor).first else {
            throw RepositoryError.entityNotFound
        }

        modelContext?.delete(planScheme)
        try deleteMindMap(by: plan.mindMapId)

        try modelContext?.save()
    }

    public func updatePlan(_ plan: Plan) throws {
        let id = plan.id
        let predicate = #Predicate<PlanScheme> { $0.identifier == id }
        let descriptor = FetchDescriptor<PlanScheme>(predicate: predicate)

        guard let planScheme = try modelContext?.fetch(descriptor).first else {
            throw RepositoryError.entityNotFound
        }

        planScheme.title = plan.title
        planScheme.overallStepsCount = plan.overallStepsCount
        planScheme.finishedStepsCount = plan.finishedStepsCount
        planScheme.color = plan.color
        planScheme.startDate = plan.startDate
        planScheme.nextDeadlineDate = plan.nextDeadlineDate
        planScheme.mindMapId = plan.mindMapId

        try modelContext?.save()
    }
}
