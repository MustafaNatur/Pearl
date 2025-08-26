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
    @State var creationSheetIsPresented: Bool = false
    @State var planToEdit: Plan? = nil
    @Namespace private var namespace

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

    public init(
        presentable: Presentable,
        onCreatePlanTapped: @escaping (Plan) -> Void,
        onEditPlanTapped: @escaping (Plan) -> Void,
        onDeletePlan: @escaping (Plan) -> Void = { _ in }
    ) {
        self.presentable = presentable
        self.onCreatePlanTapped = onCreatePlanTapped
        self.onEditPlanTapped = onEditPlanTapped
        self.onDeletePlan = onDeletePlan
    }

    let presentable: Presentable
    let onCreatePlanTapped: (Plan) -> Void
    let onEditPlanTapped: (Plan) -> Void
    let onDeletePlan: (Plan) -> Void

    public var body: some View {
        NavigationStack {
            PlansView
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    FloatingCreateActionButton
                        .padding(.trailing, 20)
                        .padding(.bottom, 34)
                }
                .sheet(isPresented: $creationSheetIsPresented) {
                    PlanFormView(intention: .create, onTapAction: onCreatePlanTapped)
                }
                .sheet(item: $planToEdit) { plan in
                    PlanFormView(intention: .edit(plan), onTapAction: onEditPlanTapped)
                }
        }
    }

    private var PlansView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                HeaderView
                PlansList
            }
            .overlay {
                if presentable.plans.isEmpty {
                    EmptyStateView
                        .fixedSize(horizontal: false, vertical: true)
                        .visualEffect { content, proxy in
                            content
                                .offset(y: ((proxy.bounds(of: .scrollView)?.height ?? 0) - 50) / 2)
                        }
                }
            }
            .padding(.horizontal, 16)

        }
        .scrollIndicators(.never)
        .scrollBounceBehavior(.basedOnSize)
    }

    private var FloatingCreateActionButton: some View {
        Button {
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            creationSheetIsPresented = true
        }
        label: {
            ZStack {
                // Main button with gradient background
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.9),
                                Color.blue.opacity(0.7),
                                Color.blue.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .shadow(color: Color.blue.opacity(0.4), radius: 16, x: 0, y: 8)
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                
                // Glass effect overlay
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.3),
                                .clear,
                                .white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                
                // Subtle border
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.4), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .frame(width: 64, height: 64)
                
                // Plus icon with shadow
                Image(systemName: "plus")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
        }
        .buttonStyle(FloatingButtonStyle())
    }

    private var PlansList: some View {
        ForEach(presentable.plans) { plan in
            NavigationLink {
                MindMapContainer()
            } label: {
                PlanCardView(
                    presentable: PlanCardView.Presentable(
                        title: plan.title,
                        overallStepsCount: plan.overallStepsCount,
                        finishedStepsCount: plan.finishedStepsCount,
                        color: Color(hex: plan.color, alpha: 1),
                        startDate: plan.startDate,
                        nextDeadlineDate: plan.nextDeadlineDate
                    )

                )
                .matchedTransitionSource(id: plan.id, in: namespace)
                .contextMenu {
                    PlanContextMenu(plan: plan)
                }
            }
        }
    }
    
    private func PlanContextMenu(plan: Plan) -> some View {
        Group {
            Button {
                planToEdit = plan
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
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.1),
                                    Color.blue.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 48, weight: .light))
                        .foregroundColor(.blue.opacity(0.6))
                }

                Text("No Plans Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 32)
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
}

// MARK: - Custom Button Style
struct FloatingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    PlansScreenView(
        presentable: PlansScreenView.Presentable(
            username: "Mustafa",
            currentFormattedDate: "June 23",
            plans: []
        ),
        onCreatePlanTapped: { _ in
            print("Create plan tapped!")
        },
        onEditPlanTapped: { _ in
            print("Edit plan tapped!")
        },
        onDeletePlan: { plan in
            print("Delete plan: \(plan.title)")
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
        onCreatePlanTapped: { _ in
            print("Create plan tapped!")
        },
        onEditPlanTapped: { _ in
            print("Edit plan tapped!")
        },
        onDeletePlan: { plan in
            print("Delete plan: \(plan.title)")
        }
    )
}
