//
//  SwiftUIView.swift
//  PlansScreen
//
//  Created by Mustafa on 23.06.2025.
//

import SwiftUI
import SharedModels
import UIToolBox

public struct PlansScreenView: View {
    public struct Presentable {
        let username: String
        let currentFormattedDate: String
        let plans: [Plan]

        public init(username: String, currentFormattedDate: String, plans: [Plan]) {
            self.username = username
            self.currentFormattedDate = currentFormattedDate
            self.plans = plans
        }
    }

    public init(presentable: Presentable) {
        self.presentable = presentable
    }

    let presentable: Presentable

    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                HeaderView
                LazyVStack(spacing: 16) {
                    PlansList
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.never)
    }

    private var PlansList: some View {
        ForEach(presentable.plans) { plan in
            PlanCardView(
                presentable: PlanCardView.Presentable(
                    title: plan.title,
                    description: plan.description,
                    emoji: plan.emoji,
                    overallStepsCount: plan.overallStepsCount,
                    finishedStepsCount: plan.finishedStepsCount,
                    color: Color(hex: plan.color, alpha: 1)
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
        )
    )
}
