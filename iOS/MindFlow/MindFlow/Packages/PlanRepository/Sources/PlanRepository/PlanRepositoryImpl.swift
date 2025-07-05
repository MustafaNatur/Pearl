//
//  File.swift
//  PlanRepository
//
//  Created by Mustafa on 05.07.2025.
//

import Foundation
import SharedModels
import SwiftData

@ModelActor
public actor PlanRepositoryImpl: PlanRepository {
    enum PlanError: Error {
        case planNorFound
    }

    public func fetchPlans() throws -> [Plan] {
        let descriptor = FetchDescriptor<PersistentPlan>()
        return try modelContext.fetch(descriptor).map(\.plan)
    }

    public func savePlan(_ plan: Plan) throws {
        modelContext.insert(plan.persistentPlan)
        try modelContext.save()
    }

    public func deletePlan(_ plan: Plan) throws {
        modelContext.delete(plan.persistentPlan)
        try modelContext.save()
    }

    public func updatePlan(_ planId: String, planSnapshot: Plan) throws {
        let predicate = #Predicate<PersistentPlan> { $0.identifier == planId }
        let descriptor = FetchDescriptor<PersistentPlan>(predicate: predicate)

        guard let plan = try modelContext.fetch(descriptor).first else {
            throw PlanError.planNorFound
        }

        plan.title = planSnapshot.title
        plan.overallStepsCount = planSnapshot.overallStepsCount
        plan.finishedStepsCount = planSnapshot.finishedStepsCount
        plan.color = planSnapshot.color
        plan.startDate = planSnapshot.startDate
        plan.nextDeadlineDate = planSnapshot.nextDeadlineDate

        try modelContext.save()
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
