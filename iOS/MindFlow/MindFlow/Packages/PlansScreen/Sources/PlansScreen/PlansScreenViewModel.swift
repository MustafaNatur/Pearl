//
//  SwiftUIView.swift
//  PlansScreen
//
//  Created by Mustafa on 23.06.2025.
//

import SwiftUI
import SharedModels
import PlanRepository
import SwiftData

enum SortingOption: String, CaseIterable, Identifiable {
    case name, startDate
    var id: Self { self }
}

@Observable
final class PlansScreenViewModel {
    private(set) var presentable: PlansScreenView.Presentable?
    var creationSheetIsPresented: Bool = false
    var planToEdit: Plan? = nil
    var sortingOption: SortingOption = .name {
        didSet {
            updateSortedPlans()
        }
    }
    var searchText: String = "" {
        didSet {
            updateFilteredPlans()
        }
    }

    private var plansStorage: [Plan] = []
    private let userService: UserService
    private let dateService: DateService
    private let planRepository: PlanRepository

    init(
        userService: UserService = UserServiceImpl(),
        dateService: DateService = DateServiceImpl(),
        planRepository: PlanRepository = RepositoryImpl()
    ) {
        self.userService = userService
        self.dateService = dateService
        self.planRepository = planRepository
    }

    func onEditPlan(_ plan: Plan) {
        planToEdit = plan
    }

    func onPresentCreationSheet() {
        creationSheetIsPresented = true
    }

    func fetchPlans() {
        guard let plans = try? planRepository.fetchPlans() else {
            presentable = nil
            return
        }

        plansStorage = plans
        updateFilteredPlans()
        updateSortedPlans()
    }

    private func updateSortedPlans() {
        let sortedPlans = switch sortingOption {
        case .name:
            presentable?.plans.sorted { $0.title < $1.title }
        case .startDate:
            presentable?.plans.sorted { $0.startDate < $1.startDate }
        }

        withAnimation {
            presentable?.plans = sortedPlans ?? []
        }
    }

    private func updateFilteredPlans() {
        let filteredPlans: [Plan]
        
        if searchText.isEmpty {
            filteredPlans = plansStorage
        } else {
            let lowercasedSearch = searchText.lowercased()
            filteredPlans = plansStorage.filter { plan in
                plan.title.lowercased().contains(lowercasedSearch)
            }
        }
        
        withAnimation {
            presentable = PlansScreenView.Presentable(
                username: userService.getCurrentUsername(),
                currentFormattedDate: dateService.getCurrentFormattedDate(),
                plans: filteredPlans
            )
        }
    }

    func onCreatePlanTapped(_ plan: Plan) {
        try? planRepository.createPlan(plan)
        fetchPlans()
    }

    func onEditPlanTapped(_ plan: Plan) {
        try? planRepository.updatePlan(plan)
        fetchPlans()
    }

    func onDeletePlan(_ plan: Plan) {
        do {
            try planRepository.deletePlan(plan)
            fetchPlans() // Refresh the plans list after deletion
        } catch {
            // TODO: Handle error - could show an alert or log the error
            print("Failed to delete plan: \(error)")
        }
    }

    func presentPlanCreationSheet() {}
}
