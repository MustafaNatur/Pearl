//
//  File.swift
//  PlanRepository
//
//  Created by Mustafa on 05.07.2025.
//

import Foundation
import SharedModels
import SwiftData

// TODO: UUID to string for id in domain models
// TODO: decopose PlanRepositoryImpl in files
// TODO: Id creation in repository
// read one more time https://medium.com/@samhastingsis/use-swiftdata-like-a-boss-92c05cba73bf
// https://medium.com/@gauravharkhanxi01/designing-efficient-local-first-architectures-with-swiftdata-cc74048526f2
// https://medium.com/@darrenthiores/the-ultimate-guide-to-swiftdata-in-mvvm-achieves-separation-of-concerns-12305f9e82d1

public final class RepositoryImpl: PlanRepository {
    enum RepositoryError: Error {
        case entityNotFound
    }

    let modelContext: ModelContext?

    public init(modelContext: ModelContext? = SwiftDataContextManager.shared.context) {
        self.modelContext = modelContext
    }
}
