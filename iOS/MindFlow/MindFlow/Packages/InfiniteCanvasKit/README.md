# InfiniteCanvasKit

Scrollable and pinch‑zoomable SwiftUI canvas with a tiled dot background, like Apple Freeform. Backed by UIScrollView for smooth performance.

## Installation (Swift Package Manager)

- Xcode → File → Add Packages…
- Search for your repository URL or add local path
- Add the `InfiniteCanvasKit` product to your app target

## Usage

```swift
import InfiniteCanvasKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        InfiniteCanvasView(
            contentSize: CGSize(width: 10000, height: 10000),
            spacing: 28,
            dotDiameter: 3,
            dotColor: .gray.opacity(0.7),
            backgroundColor: Color(white: 0.98),
            minZoom: 0.25,
            maxZoom: 5,
            initialZoom: 1,
            showsIndicators: false,
            doubleTapZoomFactor: 1.8
        ) {
            // Your nodes here
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .frame(width: 320, height: 220)
                .shadow(radius: 12)
        }
        .ignoresSafeArea()
    }
}
```

## Parameters
- contentSize: World size in points (large for “infinite-feel”).
- spacing: Distance between dots.
- dotDiameter: Dot size.
- minZoom/maxZoom/initialZoom: Zoom configuration.
- showsIndicators: Shows scroll indicators if true.
- doubleTapZoomFactor: Zoom multiplier on double-tap.

## Notes
- Dots scale with content. To keep them screen‑constant, render the background outside the zoomed content.
- iOS 16+. Marked @MainActor for UI safety.
