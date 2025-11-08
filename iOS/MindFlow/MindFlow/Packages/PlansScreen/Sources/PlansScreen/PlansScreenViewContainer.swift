//
//  SwiftUIView.swift
//  PlansScreen
//
//  Created by Mustafa on 02.07.2025.
//

import SwiftUI
import PlanCreation

public struct PlansScreenViewContainer: View {
    @State var viewModel = PlansScreenViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            PlansScreenView(
                presentable: viewModel.presentable ?? .empty,
                onDeletePlan: viewModel.onDeletePlan,
                onEditPlan: viewModel.onEditPlan,
                onPresentCreationSheet: viewModel.onPresentCreationSheet,
                onAppear: viewModel.fetchPlans
            )
            .redacted(reason: viewModel.presentable == nil ? .placeholder : [])
            .sheet(isPresented: $viewModel.creationSheetIsPresented) {
                PlanFormView(intention: .create, onTapAction: viewModel.onCreatePlanTapped)
            }
            .sheet(item: $viewModel.planToEdit) { plan in
                PlanFormView(intention: .edit(plan), onTapAction: viewModel.onEditPlanTapped)
            }
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .automatic
        )

    }
}

fileprivate extension PlansScreenView.Presentable {
    static var empty: PlansScreenView.Presentable {
        PlansScreenView.Presentable(
            username: "###",
            currentFormattedDate: "###",
            plans: .mockArray
        )
    }
}

#Preview {
    PlansScreenViewContainer()
}
