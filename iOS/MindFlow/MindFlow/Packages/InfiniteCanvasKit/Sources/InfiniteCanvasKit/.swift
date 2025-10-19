//
//  YourParentView.swift
//  InfiniteCanvasKit
//
//  Created by Mustafa on 15.09.2025.
//


struct YourParentView: View {
    @State private var contentSize: CGSize = .zero
    
    var body: some View {
        ZoomableScrollView(
            contentSize: contentSize,
            minZoomScale: minZoom,
            maxZoomScale: maxZoom,
            initialZoomScale: initialZoom,
            showsIndicators: showsIndicators,
            doubleTapZoomFactor: doubleTapZoomFactor
        ) {
            GeometryReader { proxy in
                content()
                    .background(
                        GeometryReader { innerProxy in
                            Color.clear
                                .preference(key: ContentSizeKey.self, value: innerProxy.size)
                        }
                    )
            }
        }
        .onPreferenceChange(ContentSizeKey.self) { size in
            contentSize = size
        }
    }
    
    @ViewBuilder
    private func content() -> some View {
        // Your actual content here
        // For example:
        VStack {
            // Your nodes or other content
        }
    }
}