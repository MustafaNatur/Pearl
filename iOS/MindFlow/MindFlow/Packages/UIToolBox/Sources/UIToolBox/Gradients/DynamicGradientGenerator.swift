import SwiftUI

// MARK: - Dynamic Gradient Generator
extension MeshGradient {
    
    /// Generates a beautiful mesh gradient with the given color as the main accent
    /// Creates soft complementary colors for a smooth multi-color gradient effect
    /// - Parameter accentColor: The main color to feature in the gradient
    /// - Returns: A MeshGradient with the accent color and soft complementary colors
    public static func dynamicGradient(accentColor: Color) -> MeshGradient {
        let hsl = accentColor.toHSL()
        
        // Generate 5 colors with subtle random variations for smooth transitions
        let colors = (0..<5).map { index in
            let randomHueShift = Double.random(in: -15...15)
            let randomSatShift = Double.random(in: 0.94...1.0)
            let randomLightShift = Double.random(in: 0.95...1.05)
            
            return Color.fromHSL(
                hue: (hsl.hue + randomHueShift).truncatingRemainder(dividingBy: 360),
                saturation: max(hsl.saturation * randomSatShift, 0.3),
                lightness: max(min(hsl.lightness * randomLightShift, 0.95), 0.2)
            )
        }
        
        // Create 4x4 mesh grid with randomized colors only
        let gridColors = (0..<16).map { _ in
            [accentColor] + colors
        }.flatMap { $0 }.shuffled().prefix(16)
        
        return MeshGradient(
            width: 4,
            height: 4,
            points: [
                .init(0.0, 0.0), .init(0.33, 0.0), .init(0.67, 0.0), .init(1.0, 0.0),
                .init(0.0, 0.33), .init(0.33, 0.33), .init(0.67, 0.33), .init(1.0, 0.33),
                .init(0.0, 0.67), .init(0.33, 0.67), .init(0.67, 0.67), .init(1.0, 0.67),
                .init(0.0, 1.0), .init(0.33, 1.0), .init(0.67, 1.0), .init(1.0, 1.0)
            ],
            colors: Array(gridColors)
        )
    }
}

// MARK: - Color HSL Extension
extension Color {
    
    /// Converts Color to HSL (Hue, Saturation, Lightness)
    func toHSL() -> (hue: Double, saturation: Double, lightness: Double) {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return (
            hue: Double(hue * 360),
            saturation: Double(saturation),
            lightness: Double(brightness)
        )
    }
    
    /// Creates Color from HSL values
    static func fromHSL(hue: Double, saturation: Double, lightness: Double) -> Color {
        let hueNormalized = hue / 360.0
        return Color(
            hue: hueNormalized,
            saturation: saturation,
            brightness: lightness
        )
    }
}

// MARK: - Convenience Extensions
extension Color {
    
    /// Generates a soft dynamic mesh gradient with this color as the accent
    public var dynamicGradient: MeshGradient {
        return MeshGradient.dynamicGradient(accentColor: self)
    }
}
