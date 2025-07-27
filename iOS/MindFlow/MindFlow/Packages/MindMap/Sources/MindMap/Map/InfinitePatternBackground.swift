import SwiftUI

struct InfinitePatternBackground: View {
    let scale: CGFloat
    let offset: CGSize
    
    // Base values that will be scaled
    private let baseSpacing: CGFloat = 20
    private let baseDotRadius: CGFloat = 2
    
    private var scaledSpacing: CGFloat {
        baseSpacing * scale
    }
    
    private var scaledDotRadius: CGFloat {
        // Dots scale more subtly than the spacing to maintain visual harmony
        baseDotRadius * pow(scale, 0.5)
    }

    var body: some View {
        Background
            .background(Color.white)
            .ignoresSafeArea()
    }

    var Background: some View {
        Canvas { context, size in
            let horizontalDotsCount = Int(size.width / scaledSpacing) + 2
            let verticalDotsCount = Int(size.height / scaledSpacing) + 2
            
            // Calculate the scaled offset to maintain pattern alignment
            let scaledOffsetX = offset.width.truncatingRemainder(dividingBy: scaledSpacing)
            let scaledOffsetY = offset.height.truncatingRemainder(dividingBy: scaledSpacing)

            for x in 0..<horizontalDotsCount {
                for y in 0..<verticalDotsCount {
                    let xPos = CGFloat(x) * scaledSpacing + scaledOffsetX
                    let yPos = CGFloat(y) * scaledSpacing + scaledOffsetY

                    let dotPath = Path(ellipseIn: CGRect(
                        x: xPos - scaledDotRadius,
                        y: yPos - scaledDotRadius,
                        width: scaledDotRadius * 2,
                        height: scaledDotRadius * 2
                    ))

                    context.fill(dotPath, with: .color(.gray.opacity(0.3)))
                }
            }
        }
    }
}

#Preview {
    MoveAndScaleLayout { scale, offset in
        InfinitePatternBackground(scale: scale, offset: offset)
    }
}
