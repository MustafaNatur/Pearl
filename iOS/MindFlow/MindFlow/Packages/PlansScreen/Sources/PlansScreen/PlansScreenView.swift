//
//  SwiftUIView.swift
//  PlansScreen
//
//  Created by Mustafa on 23.06.2025.
//

import SwiftUI
import SharedModels
import UIToolBox
import PlanCreationContextMenu

public struct PlansScreenView: View {
    @State var isPresented: Bool = false

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
        onAddPlanTapped: @escaping () -> Void
    ) {
        self.presentable = presentable
        self.onAddPlanTapped = onAddPlanTapped
    }

    let presentable: Presentable
    let onAddPlanTapped: () -> Void

    public var body: some View {
        PlansCollection
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                FloatingActionButton
                    .padding(.trailing, 20)
                    .padding(.bottom, 34)
            }
            .sheet(isPresented: $isPresented) {
                PlanCreationFormView()
            }
    }

    private var PlansCollection: some View {
        ScrollView {
            VStack(spacing: 32) {
                HeaderView
                LazyVStack(spacing: 16) {
                    PlansList
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.never)
    }

    private var FloatingActionButton: some View {
        Button {
            isPresented = true
        }
        label: {
            Image(systemName: "plus")
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.blue)
                .clipShape(.circle)
        }
    }

    private var PlansList: some View {
        ForEach(presentable.plans) { plan in
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
        }
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PlansScreenView(
        presentable: PlansScreenView.Presentable(
            username: "Mustafa",
            currentFormattedDate: "June 23",
            plans: .mockArray
        ),
        onAddPlanTapped: {
            print("Add plan tapped!")
        }
    )
}
