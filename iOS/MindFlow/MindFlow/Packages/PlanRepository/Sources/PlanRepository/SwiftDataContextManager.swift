//
//  SwiftDataContextManager.swift
//  PlanRepository
//
//  Created by Mustafa on 05.07.2025.
//


import Foundation
import SwiftData
import SharedModels

public class SwiftDataContextManager{
    nonisolated(unsafe) public static let shared = SwiftDataContextManager()

    public var container: ModelContainer?
    public var context : ModelContext?

    private init() {
        do {
            container = try ModelContainer(for: 
                PlanScheme.self,
                MindMapScheme.self,
                NodeScheme.self,
                ConnectionScheme.self,
                TaskScheme.self
            )
            if let container {
                context = ModelContext(container)
            }
        } catch {
            debugPrint("Error initializing database container:", error)
        }
    }
}
