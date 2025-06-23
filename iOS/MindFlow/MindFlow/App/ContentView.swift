//
//  ContentView.swift
//  MindFlow
//
//  Created by Mustafa on 22.06.2025.
//

import SwiftUI
import PlansScreen

struct MainView: View {
    var body: some View {
        PlansScreenView(
            presentable: PlansScreenView.Presentable(
                username: "Mustafa",
                currentFormattedDate: "June 23",
                plans: .mockArray
            )
        )
    }
}

#Preview {
    MainView()
}
