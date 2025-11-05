import UIKit

@MainActor
final class Constants {
    static let minScale: CGFloat = 0.08
    static let maxScale: CGFloat = 4.0
    static let canvasSize: CGSize = CGSize(
        width: Device.screenWidth / minScale,
        height: Device.screenHeight / minScale
    )
}

@MainActor
enum Device {
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
}
