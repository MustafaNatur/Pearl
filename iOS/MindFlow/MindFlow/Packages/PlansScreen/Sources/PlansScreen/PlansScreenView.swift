//
//  PlansScreenView.swift
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }

    private var PlansView: some View {
        PlansList
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
    }

    private var PlansList: some View {
        List(presentable.plans) { plan in
            PlanCardView(
                presentable: PlanCardView.Presentable(
                    title: plan.title,
                    overallStepsCount: plan.overallStepsCount,
                    finishedStepsCount: plan.finishedStepsCount,
                    color: Color(hex: plan.color),
                    gradientSeed: plan.id,
                    startDate: plan.startDate,
                    deadlineDate: plan.deadlineDate
                )

            )
            .background {
                NavigationLink {
                    MindMapContainer(mindMapId: plan.mindMapId)
                } label: {
                    EmptyView()
                }
            }
            .contextMenu {
                PlanContextMenu(plan: plan)
            }
            .shadow(color: Color(hex: plan.color),radius: 5)
            .contentShape(.contextMenuPreview, .rect(cornerRadius: 24))
            .padding(.horizontal, 16)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .swipeActions(edge: .trailing) {
                SwipeActions(plan: plan)
            }
        }
        .listRowSpacing(26)
        .listStyle(PlainListStyle())
        .background(Color.clear)
    }

    @ViewBuilder
    private func SwipeActions(plan: Plan) -> some View {
        Button(role: .destructive) {
            onDeletePlan(plan)
        } label: {
            VStack {
                Image(systemName: "wrongwaysign.fill")
                Text("Delete")
            }
        }

        Button {
            onEditPlan(plan)
        } label: {
            VStack {
                Image(systemName: "pencil")
                Text("Edit")
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
                        .background(Color.accentMindFlowColor.dynamicGradient)
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
