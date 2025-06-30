import SwiftUI

struct PlanCardView: View {
    struct Presentable {
        let title: String
        let description: String?
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
            // Start Date Label
            VStack(alignment: .leading, spacing: 4) {
                Text(dateFormatter.string(from: presentable.startDate))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("Started")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.7))
                    .textCase(.uppercase)
            }

            Spacer()

            // Next Deadline Label
            if let nextDeadlineDate = presentable.nextDeadlineDate {
                VStack(alignment: .leading, spacing: 4) {
                    Text(dateFormatter.string(from: nextDeadlineDate))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Text("Next Deadline")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.7))
                        .textCase(.uppercase)
                }
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Status")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.7))
                        .textCase(.uppercase)
                    
                    Text("Completed")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
        }
    }

    private var ProgressData: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(presentable.progressText)
                .font(.callout)
                .foregroundColor(.white.opacity(0.9))
            ProgressBar
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
        Double(finishedStepsCount) / Double(overallStepsCount)
    }
    var progressText: String {
        "\(finishedStepsCount) of \(overallStepsCount) steps"
    }
}

extension PlanCardView.Presentable {
    static let mock = PlanCardView.Presentable(
        title: "How to play bascketball",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
        overallStepsCount: 12,
        finishedStepsCount: 7,
        color: .blue,
        startDate: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date(),
        nextDeadlineDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())
    )
}

#Preview {
    PlanCardView(presentable: .mock)
        .padding(.horizontal, 16)
}
