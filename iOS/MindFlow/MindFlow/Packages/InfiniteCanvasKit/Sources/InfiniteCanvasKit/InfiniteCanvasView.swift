import SwiftUI

/// Infinite‑feel, scrollable and zoomable canvas with dotted background (like Freeform).
public struct InfiniteCanvasView<Content: View>: View {
    public let contentSize: CGSize
    public let spacing: CGFloat
    public let dotDiameter: CGFloat
    public let dotColor: Color
    public let backgroundColor: Color
    public let minZoom: CGFloat
    public let maxZoom: CGFloat
    public let initialZoom: CGFloat
    public let showsIndicators: Bool
    public let doubleTapZoomFactor: CGFloat
    @ViewBuilder public var content: () -> Content

    public init(
        contentSize: CGSize = CGSize(width: 20000, height: 20000),
        spacing: CGFloat = 28,
        dotDiameter: CGFloat = 2,
        dotColor: Color = Color(white: 0.75),
        backgroundColor: Color = Color(white: 0.98),
        minZoom: CGFloat = 1,
        maxZoom: CGFloat = 5.0,
        initialZoom: CGFloat = 1.0,
        showsIndicators: Bool = false,
        doubleTapZoomFactor: CGFloat = 1.8,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.contentSize = contentSize
        self.spacing = spacing
        self.dotDiameter = dotDiameter
        self.dotColor = dotColor
        self.backgroundColor = backgroundColor
        self.minZoom = minZoom
        self.maxZoom = maxZoom
        self.initialZoom = initialZoom
        self.showsIndicators = showsIndicators
        self.doubleTapZoomFactor = doubleTapZoomFactor
        self.content = content
    }

    public var body: some View {
        ZoomableScrollView(
            contentSize: contentSize,
            minZoomScale: minZoom,
            maxZoomScale: maxZoom,
            initialZoomScale: initialZoom,
            showsIndicators: showsIndicators,
            doubleTapZoomFactor: doubleTapZoomFactor
        ) {
            ZStack {
                DotGridBackground(
                    spacing: spacing,
                    dotDiameter: dotDiameter,
                    dotColor: dotColor,
                    backgroundColor: backgroundColor
                )
                content()
            }
            .frame(width: contentSize.width, height: contentSize.height)
        }
    }
}


