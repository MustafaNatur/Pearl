//
//  File.swift
//  PlanRepository
//
//  Created by Mustafa on 05.07.2025.
//

import Foundation
import SharedModels
import SwiftData

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
        let descriptor = FetchDescriptor<PersistentPlan>()
        return try modelContext?.fetch(descriptor).map(\.plan) ?? []
    }

    public func savePlan(_ plan: Plan) throws {
        modelContext?.insert(plan.persistentPlan)
        try modelContext?.save()
    }

    public func deletePlan(_ plan: Plan) throws {
        let id = plan.id
        let predicate = #Predicate<PersistentPlan> { $0.identifier == id }
        let descriptor = FetchDescriptor<PersistentPlan>(predicate: predicate)

        guard let plan = try modelContext?.fetch(descriptor).first else {
            throw PlanError.planNorFound
        }

        modelContext?.delete(plan)

        try modelContext?.save()
    }

    public func updatePlan(_ plan: Plan) throws {
        let id = plan.id
        let predicate = #Predicate<PersistentPlan> { $0.identifier == id }
        let descriptor = FetchDescriptor<PersistentPlan>(predicate: predicate)

        guard let persistentplan = try modelContext?.fetch(descriptor).first else {
            throw PlanError.planNorFound
        }

        persistentplan.title = plan.title
        persistentplan.overallStepsCount = plan.overallStepsCount
        persistentplan.finishedStepsCount = plan.finishedStepsCount
        persistentplan.color = plan.color
        persistentplan.startDate = plan.startDate
        persistentplan.nextDeadlineDate = plan.nextDeadlineDate

        try modelContext?.save()
    }
}

fileprivate extension Plan {
    var persistentPlan: PersistentPlan {
        PersistentPlan(
            identifier: id,
            title: title,
            overallStepsCount: overallStepsCount,
            finishedStepsCount: finishedStepsCount,
            color: color,
            startDate: startDate,
            nextDeadlineDate: nextDeadlineDate
        )
    }
}

fileprivate extension PersistentPlan {
    var plan: Plan {
        Plan(
            id: identifier,
            title: title,
            overallStepsCount: overallStepsCount,
            finishedStepsCount: finishedStepsCount,
            color: color,
            startDate: startDate,
            nextDeadlineDate: nextDeadlineDate
        )
    }
}
