//
//  File.swift
//  PlanRepository
//
//  Created by Mustafa on 05.07.2025.
//

import Foundation
import SharedModels

public protocol PlanRepository {
    func fetchPlans() throws -> [Plan]
    func createPlan(_ plan: Plan) throws
    func deletePlan(_ plan: Plan) throws
    func updatePlan(_ plan: Plan) throws
}
