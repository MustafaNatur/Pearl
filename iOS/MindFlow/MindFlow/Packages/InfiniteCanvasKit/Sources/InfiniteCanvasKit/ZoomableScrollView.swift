import SwiftUI
import UIKit

@MainActor
public struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    private let contentSize: CGSize
    private let minZoomScale: CGFloat
    private let maxZoomScale: CGFloat
    private let initialZoomScale: CGFloat
    private let showsIndicators: Bool
    private let doubleTapZoomFactor: CGFloat
    private let directionalLockEnabled: Bool
    @ViewBuilder private var content: () -> Content

    public init(
        contentSize: CGSize,
        minZoomScale: CGFloat = 0.25,
        maxZoomScale: CGFloat = 4.0,
        initialZoomScale: CGFloat = 1.0,
        showsIndicators: Bool = false,
        doubleTapZoomFactor: CGFloat = 1.8,
        directionalLockEnabled: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.contentSize = contentSize
        self.minZoomScale = minZoomScale
        self.maxZoomScale = maxZoomScale
        self.initialZoomScale = initialZoomScale
        self.showsIndicators = showsIndicators
        self.doubleTapZoomFactor = doubleTapZoomFactor
        self.directionalLockEnabled = directionalLockEnabled
        self.content = content
    }

    public func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = minZoomScale
        scrollView.maximumZoomScale = maxZoomScale
        scrollView.zoomScale = initialZoomScale
        scrollView.delegate = context.coordinator
        scrollView.showsHorizontalScrollIndicator = showsIndicators
        scrollView.showsVerticalScrollIndicator = showsIndicators
        scrollView.bouncesZoom = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.decelerationRate = .fast
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
//        scrollView.isDirectionalLockEnabled = directionalLockEnabled

        let container = UIView(frame: CGRect(origin: .zero, size: contentSize))
        container.backgroundColor = .clear

        let hosting = UIHostingController(rootView: content())
        hosting.view.backgroundColor = .clear
        hosting.view.frame = container.bounds
        hosting.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        container.addSubview(hosting.view)
        scrollView.addSubview(container)

        context.coordinator.containerView = container
        context.coordinator.hostingController = hosting
        context.coordinator.scrollView = scrollView
        context.coordinator.doubleTapZoomFactor = doubleTapZoomFactor

        scrollView.contentSize = contentSize

        DispatchQueue.main.async {
            let centerOffset = CGPoint(
                x: max(0, (scrollView.contentSize.width - scrollView.bounds.width) / 2.0),
                y: max(0, (scrollView.contentSize.height - scrollView.bounds.height) / 2.0)
            )
            scrollView.setContentOffset(centerOffset, animated: false)
        }

        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        return scrollView
    }

    public func updateUIView(_ scrollView: UIScrollView, context: Context) {
        if let hosting = context.coordinator.hostingController {
            hosting.rootView = content()
        }
        context.coordinator.containerView?.frame.size = contentSize
        scrollView.contentSize = contentSize
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    @MainActor
    public class Coordinator: NSObject, UIScrollViewDelegate {
        weak var scrollView: UIScrollView?
        weak var containerView: UIView?
        var hostingController: UIHostingController<Content>?
        var doubleTapZoomFactor: CGFloat = 1.8

        public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            containerView
        }

        @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            guard let scrollView = scrollView, let containerView = containerView else { return }
            let point = gesture.location(in: containerView)
            let newScale = min(scrollView.zoomScale * doubleTapZoomFactor, scrollView.maximumZoomScale)
            let width = scrollView.bounds.width / newScale
            let height = scrollView.bounds.height / newScale
            let x = point.x - (width / 2.0)
            let y = point.y - (height / 2.0)
            let zoomRect = CGRect(x: x, y: y, width: width, height: height)
            scrollView.zoom(to: zoomRect, animated: true)
        }

        public func scrollViewDidZoom(_ scrollView: UIScrollView) {
            guard let containerView = containerView else { return }
            let boundsSize = scrollView.bounds.size
            let contentFrame = containerView.frame
            let horizontalInset = max(0, (boundsSize.width - contentFrame.width) / 2)
            let verticalInset = max(0, (boundsSize.height - contentFrame.height) / 2)
            scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        }
    }
}


