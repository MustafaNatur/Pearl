//
//  SwiftUIView.swift
//  PlansScreen
//
//  Created by Mustafa on 23.06.2025.
//

import SwiftUI
import SharedModels
import UIToolBox

struct PlansScreenView: View {
    struct Presentable {
        let username: String
        let currentFormattedDate: String
        let plans: [Plan]
    }

    let presentable: Presentable

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 32) {
                HeaderView
                PlansList
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
            Text("Welcome Back!")
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
