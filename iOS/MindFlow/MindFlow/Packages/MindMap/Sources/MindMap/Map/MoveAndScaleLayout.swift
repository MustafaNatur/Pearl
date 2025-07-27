import SwiftUI

struct MoveAndScaleLayout<Content: View>: View {
    let movableAndScalableContent: (CGFloat, CGSize) -> Content

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        movableAndScalableContent(scale, offset)
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / self.lastScale
                            self.lastScale = value
                            self.scale *= delta
                        }
                        .onEnded { _ in
                            self.lastScale = 1.0
                        },
                    DragGesture()
                        .onChanged { value in
                            self.offset = CGSize(width: self.lastOffset.width + value.translation.width, height: self.lastOffset.height + value.translation.height)
                        }
                        .onEnded { _ in
                            self.lastOffset = self.offset
                        }
                )
            )
    }
}
