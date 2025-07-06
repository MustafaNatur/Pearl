//
//  SwiftUIView.swift
//  PlansScreen
//
//  Created by Mustafa on 02.07.2025.
//

import SwiftUI
import PlanCreationContextMenu

public struct PlansScreenViewContainer: View {
    @State var viewModel = PlansScreenViewModel()

    public init() {}

    public var body: some View {
        PlansScreenView(
            presentable: viewModel.presentable ?? .empty,
            onCreatePlanTapped: viewModel.onCreatePlanTapped(_:),
            onEditPlanTapped: viewModel.onEditPlanTapped(_:),
            onDeletePlan: viewModel.onDeletePlan
        )
        .onAppear(perform: viewModel.fetchPlans)
        .redacted(reason: viewModel.presentable == nil ? .placeholder : [])
    }
}

fileprivate extension PlansScreenView.Presentable {
    // Workaround MainActor
    @MainActor static let empty = PlansScreenView.Presentable(
        username: "###",
        currentFormattedDate: "###",
        plans: .mockArray
    )
}

#Preview {
    PlansScreenViewContainer()
}
