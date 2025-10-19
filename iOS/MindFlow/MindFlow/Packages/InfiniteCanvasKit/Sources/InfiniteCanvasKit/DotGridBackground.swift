import SwiftUI
import UIKit

public struct DotGridBackground: View {
    public let tile: UIImage

    public init(
        spacing: CGFloat = 28,
        dotDiameter: CGFloat = 2,
        dotColor: Color = Color(white: 0.75),
        backgroundColor: Color = Color(white: 0.98)
    ) {
        self.tile = DotGridBackground.makeTile(
            spacing: spacing,
            dotDiameter: dotDiameter,
            dotColor: UIColor(dotColor),
            backgroundColor: UIColor(backgroundColor)
        )
    }

    public var body: some View {
        Image(uiImage: tile)
            .resizable(resizingMode: .tile)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
    }

    private static func makeTile(
        spacing: CGFloat,
        dotDiameter: CGFloat,
        dotColor: UIColor,
        backgroundColor: UIColor
    ) -> UIImage {
        let size = CGSize(width: spacing, height: spacing)
        let format = UIGraphicsImageRendererFormat()
        format.opaque = true
        format.scale = 0
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { ctx in
            backgroundColor.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))

            let rect = CGRect(
                x: (spacing - dotDiameter) / 2,
                y: (spacing - dotDiameter) / 2,
                width: dotDiameter,
                height: dotDiameter
            )
            dotColor.setFill()
            ctx.cgContext.fillEllipse(in: rect)
        }
    }
}


