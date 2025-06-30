//
//  MainViewModel.swift
//  App
//
//  Created by Mustafa on 30.06.2025.
//
import SwiftUI
import PlansScreen

@MainActor
@Observable
final class MainViewModel {
    private let userService: UserService
    private let dateService: DateService
    
    init(
        userService: UserService = UserServiceImpl(),
        dateService: DateService = DateServiceImpl()
    ) {
        self.userService = userService
        self.dateService = dateService
    }
    
    var presentable: PlansScreenView.Presentable {
        PlansScreenView.Presentable(
            username: userService.getCurrentUsername(),
            currentFormattedDate: dateService.getCurrentFormattedDate(),
            plans: .mockArray
        )
    }
}
