//
//  EmptyScrollView.swift
//  DoodleApp
//
//  Created by Itsuki on 2025/05/10.
//

import SwiftUI
import PencilKit
import SwiftData

struct MoveAndScaleLayout<
    Content: View,
    Background: View
>: View {
    @Binding var previousZoomScale: CGFloat
    @Binding var previousOffset: CGPoint
    let content: () -> Content
    let background: () -> Background

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                background()
                    .frame(width: Constants.canvasSize.width, height: Constants.canvasSize.height)
                    .scaleEffect(previousZoomScale, anchor: .topLeading)
                    .offset(x: -previousOffset.x, y: -previousOffset.y)
            }
            EmptyScrollView(
                previousZoomScale: $previousZoomScale,
                previousOffset: $previousOffset
            )
            content()
                .scaleEffect(previousZoomScale, anchor: .topLeading)
                .offset(x: -previousOffset.x, y: -previousOffset.y)
        }
    }
}
