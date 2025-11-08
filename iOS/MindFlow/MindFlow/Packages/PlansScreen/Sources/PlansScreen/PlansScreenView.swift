//
//  SwiftUIView.swift
//  PlansScreen
//
//  Created by Mustafa on 23.06.2025.
//

import SwiftUI
import SharedModels
import UIToolBox
import PlanCreation
import MindMap

public struct PlansScreenView: View {
    public struct Presentable {
        let username: String
        let currentFormattedDate: String
        var plans: [Plan]

        public init(
            username: String,
            currentFormattedDate: String,
            plans: [Plan]
        ) {
            self.username = username
            self.currentFormattedDate = currentFormattedDate
            self.plans = plans
        }
    }

    let presentable: Presentable
    let onDeletePlan: (Plan) -> Void
    let onEditPlan: (Plan) -> Void
    let onPresentCreationSheet: () -> Void
    let onAppear: () -> Void

    public init(
        presentable: Presentable,
        onDeletePlan: @escaping (Plan) -> Void,
        onEditPlan: @escaping (Plan) -> Void,
        onPresentCreationSheet: @escaping () -> Void,
        onAppear: @escaping () -> Void
    ) {
        self.presentable = presentable
        self.onDeletePlan = onDeletePlan
        self.onEditPlan = onEditPlan
        self.onPresentCreationSheet = onPresentCreationSheet
        self.onAppear = onAppear
    }

    public var body: some View {
        PlansView
            .onAppear(perform: onAppear)
            .overlay {
                if noPlans {
                    EmptyStateView
                }
            }
    }

    private var PlansView: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                PlansList
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)

        }
        .scrollDisabled(presentable.plans.isEmpty)
        .scrollIndicators(.never)
        .navigationTitle("My Plans")
        .navigationSubtitle(presentable.username + ", " + presentable.currentFormattedDate)
        .toolbar {
            DefaultToolbarItem(kind: .search, placement: .bottomBar)
            ToolbarSpacer(.fixed, placement: .bottomBar)
            ToolbarItem(placement: .bottomBar) {
                Image(systemName: "square.and.pencil")
                    .padding(5)
                    .onTapGesture(perform: createPlanButtonTapped)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "line.3.horizontal.decrease")
                    .padding(5)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "checkmark.circle")
                    .padding(5)
            }
        }
    }

    private var PlansList: some View {
        ForEach(presentable.plans) { plan in
            NavigationLink {
                MindMapContainer(mindMapId: plan.mindMapId)
            } label: {
                PlanCardView(
                    presentable: PlanCardView.Presentable(
                        title: plan.title,
                        overallStepsCount: plan.overallStepsCount,
                        finishedStepsCount: plan.finishedStepsCount,
                        color: Color(hex: plan.color, alpha: 1),
                        startDate: plan.startDate,
                        deadlineDate: plan.deadlineDate
                    )

                )
                .contextMenu {
                    PlanContextMenu(plan: plan)
                }
                .shadow(radius: 5)
            }
        }
    }
    
    private func PlanContextMenu(plan: Plan) -> some View {
        Group {
            Button {
                onEditPlan(plan)
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                onDeletePlan(plan)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private var EmptyStateView: some View {
        VStack(spacing: 32) {
            VStack(spacing: 24) {
                VStack {
                    Image(systemName: "rectangle.stack.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.gray)

                    Text("No Plans")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 32)
                }

                Button(action: createPlanButtonTapped) {
                    Text("Create plan")
                        .font(.default)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color.cyan.dynamicGradient)
                        .clipShape(.capsule)
                }
                .glassEffect()
            }
        }
        .transition(.opacity.combined(with: .scale))
    }

    private func createPlanButtonTapped() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        onPresentCreationSheet()
    }

    private var noPlans: Bool {
        presentable.plans.isEmpty
    }
}

#Preview {
    PlansScreenView(
        presentable: PlansScreenView.Presentable(
            username: "Mustafa",
            currentFormattedDate: "June 23",
            plans: []
        ),
        onDeletePlan: { plan in
            print("Delete plan: \(plan.title)")
        },
        onEditPlan: { _ in
            print("onEditPlan")
        },
        onPresentCreationSheet: {
            print("onPresentCreationSheet")
        },
        onAppear: {
            print("onAppear")
        }
    )
}

#Preview {
    PlansScreenView(
        presentable: PlansScreenView.Presentable(
            username: "Mustafa",
            currentFormattedDate: "June 23",
            plans: .mockArray
        ),
        onDeletePlan: { plan in
            print("Delete plan: \(plan.title)")
        },
        onEditPlan: { _ in
            print("onEditPlan")
        },
        onPresentCreationSheet: {
            print("onPresentCreationSheet")
        },
        onAppear: {
            print("onAppear")
        }
    )
}
