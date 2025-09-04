//
//  File.swift
//  PlanRepository
//
//  Created by Mustafa on 04.09.2025.
//

import Foundation

import SharedModels

public protocol MindMapRepository {
    func fetchMindMap(_ mindMapId: String) throws -> MindMap
    func createMindMap(_ mindMap: MindMap) throws
    func deleteMindMap(by mindMapId: String) throws
    func updateMindMap(by mindMapId: String, mindMap: MindMap) throws
}
