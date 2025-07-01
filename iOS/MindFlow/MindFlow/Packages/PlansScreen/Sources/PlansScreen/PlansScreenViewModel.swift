//
//  SwiftUIView.swift
//  PlansScreen
//
//  Created by Mustafa on 23.06.2025.
//

import SwiftUI
import SharedModels

@Observable
final class PlansScreenViewModel {
    var presentable: PlansScreenView.Presentable?

    private let userService: UserService
    private let dateService: DateService


    init(
        userService: UserService = UserServiceImpl(),
        dateService: DateService = DateServiceImpl()
    ) {
        self.userService = userService
        self.dateService = dateService
    }

    func fetchPlans() {
        presentable = PlansScreenView.Presentable(
            username: userService.getCurrentUsername(),
            currentFormattedDate: dateService.getCurrentFormattedDate(),
            plans: .mockArray
        )
    }

    func onAddPlanTapped() {}

    func presentPlanCreationSheet() {
    }
}
