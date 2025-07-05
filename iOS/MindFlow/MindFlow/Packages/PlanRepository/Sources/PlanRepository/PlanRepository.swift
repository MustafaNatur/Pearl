//
//  File.swift
//  PlanRepository
//
//  Created by Mustafa on 05.07.2025.
//

import Foundation
import SharedModels

public protocol PlanRepository: Actor {
    func fetchPlans() throws -> [Plan]
    func savePlan(_ plan: Plan) throws
    func deletePlan(_ plan: Plan) throws
    func updatePlan(_ planId: String, planSnapshot: Plan) throws
}
