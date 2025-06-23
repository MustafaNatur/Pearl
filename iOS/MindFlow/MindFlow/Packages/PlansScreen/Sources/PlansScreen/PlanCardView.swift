import SwiftUI

struct PlanCardView: View {
    struct Presentable {
        let title: String
        let description: String?
        let emoji: String
        let overallStepsCount: Int
        let finishedStepsCount: Int
        let color: Color
    }

    let presentable: Presentable

    var body: some View {
        VStack(alignment: .leading) {
            TextInfo
            Spacer()
            ProgressBar
        }
        .padding(.all, 16)
        .background(backgroundGradient)
        .clipShape(.rect(cornerRadius: 24))
        .contentShape(.rect(cornerRadius: 24))
        .aspectRatio(16/9, contentMode: .fit)
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
            HStack(spacing: 8) {
                Text(presentable.emoji)
                    .font(.title)

                Text(presentable.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }

            if let description = presentable.description {
                Text(description)
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
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
        emoji: "🏀",
        overallStepsCount: 12,
        finishedStepsCount: 7,
        color: .blue
    )
}

#Preview {
    PlanCardView(presentable: .mock)
}
