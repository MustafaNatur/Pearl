
import SwiftUI
import PencilKit
import SwiftData


struct EmptyScrollView: UIViewRepresentable {
    @Binding var previousZoomScale: CGFloat
    @Binding var previousOffset: CGPoint

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        let emptyView = UIView()
        emptyView.frame = .init(origin: scrollView.frame.origin, size: Constants.canvasSize)
        scrollView.addSubview(emptyView)
        
        scrollView.delegate = context.coordinator
        
        scrollView.isOpaque = false

        scrollView.contentSize = Constants.canvasSize
        scrollView.contentOffset = previousOffset
        
        /// for zooming
        scrollView.minimumZoomScale = Constants.minScale
        scrollView.maximumZoomScale = Constants.maxScale
        scrollView.zoomScale = previousZoomScale
        
        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        if previousOffset != scrollView.contentOffset {
            scrollView.contentOffset = previousOffset
        }
        
        if previousZoomScale != scrollView.zoomScale {
            scrollView.zoomScale = previousZoomScale
        }

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: EmptyScrollView

        init(_ parent: EmptyScrollView) {
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
                self.parent.previousZoomScale = scrollView.zoomScale
                self.parent.previousOffset = scrollView.contentOffset
            }
        }
    }

}
