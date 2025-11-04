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
        let plans: [Plan]

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
                else {
                    FloatingCreateActionButton
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(.trailing, 26)
                }
            }
    }

    private var PlansView: some View {
        ScrollView {
            LazyVStack(spacing: 20){
                HeaderView
                PlansList
            }
            .padding(.horizontal, 16)
        }
        .scrollDisabled(presentable.plans.isEmpty)
        .scrollIndicators(.never)
    }

    private var FloatingCreateActionButton: some View {
        Button(action: createPlanButtonTapped) {
            Image(systemName: "plus")
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.white)
                .padding(.all, 20)
                .background(Color.blue)
                .glassEffect()
                .clipShape(.circle)
                .contentShape(.circle)
        }
        .glassEffect()
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

                    Text("No Plans Yet")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 32)
                }

                Button(action: createPlanButtonTapped) {
                    Text("Create your first plan")
                        .font(.default)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .clipShape(.capsule)
                }
                .glassEffect()
            }
        }

        .transition(.opacity.combined(with: .scale))
    }
    
    private var HeaderView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("My Plans")
                .font(.largeTitle.bold())

            HStack(spacing: 8) {
                Text(presentable.username)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text(presentable.currentFormattedDate)
                    .foregroundStyle(.gray)
            }
            .font(.title3)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
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
