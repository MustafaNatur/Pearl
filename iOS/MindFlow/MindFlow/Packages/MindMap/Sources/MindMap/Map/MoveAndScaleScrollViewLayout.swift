//
//  EmptyScrollView.swift
//  DoodleApp
//
//  Created by Itsuki on 2025/05/10.
//

import SwiftUI
import PencilKit
import SwiftData


struct MoveAndScaleScrollViewLayout<Content: View>: UIViewRepresentable {
    struct Config {
        let minScale: CGFloat
        let maxScale: CGFloat
    }

    let config: Config
    @Binding var lastScale: CGFloat
    @Binding var lastOffset: CGPoint
    let content: () -> Content



    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        
        // Create a hosting controller for the SwiftUI content
        let hostingController = UIHostingController(rootView: content())
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = .init(origin: .zero, size: config.canvasSize)
        
        scrollView.addSubview(hostingController.view)
        
        // Store the hosting controller in the coordinator
        context.coordinator.hostingController = hostingController

        scrollView.delegate = context.coordinator

        scrollView.isOpaque = false
        scrollView.backgroundColor = .clear

        scrollView.contentSize = config.canvasSize
        scrollView.contentOffset = lastOffset

        /// for zooming
        scrollView.minimumZoomScale = config.minScale
        scrollView.maximumZoomScale = config.maxScale
        scrollView.zoomScale = lastScale

        scrollView.isUserInteractionEnabled = true

        return scrollView
    }


    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        scrollView.isUserInteractionEnabled = true
        
        // Update the SwiftUI content
        context.coordinator.hostingController?.rootView = content()

        if lastOffset != scrollView.contentOffset {
            scrollView.contentOffset = lastOffset
        }

        if lastScale != scrollView.zoomScale {
            scrollView.zoomScale = lastScale
        }
    }

}

extension MoveAndScaleScrollViewLayout {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: MoveAndScaleScrollViewLayout
        var hostingController: UIHostingController<Content>?

        init(_ parent: MoveAndScaleScrollViewLayout) {
            self.parent = parent
        }

        // MARK: UIScrollViewDelegate
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return scrollView.subviews.first
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            self.updateZoomOffset(scrollView)
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            self.updateZoomOffset(scrollView)
        }

        private func updateZoomOffset(_ scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.parent.lastScale = scrollView.zoomScale
                self.parent.lastOffset = scrollView.contentOffset
            }
        }
    }
}

extension MoveAndScaleScrollViewLayout.Config {
    @MainActor
    var canvasSize: CGSize {
        CGSize(
            width: UIScreen.main.bounds.width ,
            height: UIScreen.main.bounds.height
        )
    }
}

extension MoveAndScaleScrollViewLayout.Config {
    static var `default`: Self {
        Self(minScale: 0.02, maxScale: 4.0)
    }
}
