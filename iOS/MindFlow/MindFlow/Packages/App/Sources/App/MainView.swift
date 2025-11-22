//
//  ContentView.swift
//  MindFlow
//
//  Created by Mustafa on 22.06.2025.
//

import SwiftUI
import PlansScreen
import MindAssistant

public struct MainView: View {
    public init() {}

    public var body: some View {
        TabView {
            Tab("Assistant", systemImage: "sparkles") {
                MindAssistant.DemoView()
            }

            Tab("Plans", systemImage: "sparkles.rectangle.stack.fill") {
                PlansScreenViewContainer()
            }

            Tab(role: .search) {
                Text("Search screen")
            }
        }
    }
}

#Preview {
    MainView()
}
