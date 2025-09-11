import SwiftUI
import UIToolBox

struct PlanCardView: View {
    struct Presentable {
        let title: String
        let overallStepsCount: Int
        let finishedStepsCount: Int
        let color: Color
        let startDate: Date
        let nextDeadlineDate: Date?
    }

    let presentable: Presentable
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            TextInfo
            Spacer()
            DateLabels
            Spacer()
            ProgressBar
        }
        .padding(.all, 16)
        .background(backgroundGradient)
        .clipShape(.rect(cornerRadius: 24))
        .contentShape(.rect(cornerRadius: 24))
        .aspectRatio(16/10, contentMode: .fit)
        .animation(.easeOut, value: presentable.progress)
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                presentable.color.opacity(0.8),
                presentable.color.opacity(0.4)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var TextInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(presentable.title)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }
    
    private var DateLabels: some View {
        HStack {
            DateBadge(presentable.startDate, title: "Started")

            Spacer()

            DateBadge(presentable.nextDeadlineDate, title: "Next Deadline")
        }
    }

    @ViewBuilder
    private func DateBadge(_ date: Date?, title: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let date {
                Text(dateFormatter.string(from: date))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            } else {
                Image(systemName: "infinity")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }

            Text(title)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.7))
                .textCase(.uppercase)
        }
    }

    private var ProgressBar: some View {
        VStack(alignment: .trailing, spacing: 14) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.white.opacity(0.2))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(.white)
                        .frame(width: geometry.size.width * presentable.progress)
                }
            }
            .frame(height: 8)

            HStack {
                Text(presentable.progressText)
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.9))
                Spacer()
                Text("\(Int(presentable.progress * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }
}

extension PlanCardView.Presentable {
    var progress: Double {
        Double(finishedStepsCount) / max(Double(overallStepsCount), 1)
    }
    var progressText: String {
        "\(finishedStepsCount) of \(overallStepsCount) steps"
    }
}

extension PlanCardView.Presentable {
    static func mock(hasDeadline: Bool) -> PlanCardView.Presentable {
        PlanCardView.Presentable(
            title: "How to play basketball",
            overallStepsCount: 12,
            finishedStepsCount: 7,
            color: .blue,
            startDate: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date(),
            nextDeadlineDate: hasDeadline ? Calendar.current.date(byAdding: .day, value: 5, to: Date()) : nil
        )
    }
}

#Preview {
    Group {
        PlanCardView(presentable: .mock(hasDeadline: true))
        PlanCardView(presentable: .mock(hasDeadline: false))
    }
    .padding(.horizontal, 16)
}
