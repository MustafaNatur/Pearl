//
//  ContentView.swift
//  MindFlow
//
//  Created by Mustafa on 22.06.2025.
//

import SwiftUI
import PlansScreen

public struct MainView: View {
    @State private var viewModel = MainViewModel()

    public init() {}

    public var body: some View {
        PlansScreenView(presentable: viewModel.presentable, onAddPlanTapped: {})
    }
}

#Preview {
    MainView()
}
