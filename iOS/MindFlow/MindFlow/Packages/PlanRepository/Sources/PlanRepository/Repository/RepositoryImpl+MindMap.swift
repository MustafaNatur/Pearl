//
//  RepositoryImpl+MindMap.swift
//  PlanRepository
//
//  Created by Mustafa on 04.09.2025.
//

import Foundation
import SharedModels
import SwiftData

extension RepositoryImpl: MindMapRepository {
    public func fetchMindMap(_ mindMapId: String) throws -> SharedModels.MindMap {
        let predicate = #Predicate<MindMapScheme> { $0.identifier == mindMapId }
        let descriptor = FetchDescriptor<MindMapScheme>(predicate: predicate)

        guard let mindMapScheme = try modelContext?.fetch(descriptor).first else {
            throw RepositoryError.entityNotFound
        }

        return mindMapScheme.toMindMap
    }
    
    public func createMindMap(_ mindMap: MindMap) throws {
        modelContext?.insert(mindMap.toMindMapScheme)
        try modelContext?.save()
    }
    
    public func deleteMindMap(by mindMapId: String) throws {
        let predicate = #Predicate<MindMapScheme> { $0.identifier == mindMapId }
        let descriptor = FetchDescriptor<MindMapScheme>(predicate: predicate)

        guard let mindMapScheme = try modelContext?.fetch(descriptor).first else {
            throw RepositoryError.entityNotFound
        }

        modelContext?.delete(mindMapScheme)

        try modelContext?.save()
    }
    
    public func updateMindMap(by mindMapId: String, mindMap: SharedModels.MindMap) throws {
        let predicate = #Predicate<MindMapScheme> { $0.identifier == mindMapId }
        let descriptor = FetchDescriptor<MindMapScheme>(predicate: predicate)

        guard let mindMapScheme = try modelContext?.fetch(descriptor).first else {
            throw RepositoryError.entityNotFound
        }

        mindMapScheme.connections = mindMap.connections.map(\.toConnectionScheme)
        mindMapScheme.nodes = mindMap.nodes.map(\.toNodeScheme)

        try modelContext?.save()
    }
}
