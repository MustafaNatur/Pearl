import SwiftUI

// MARK: - Dynamic Gradient Generator
extension MeshGradient {
    
    /// Generates a beautiful mesh gradient with the given color as the main accent
    /// Creates soft complementary colors for a smooth multi-color gradient effect
    /// - Parameter accentColor: The main color to feature in the gradient
    /// - Returns: A MeshGradient with the accent color and soft complementary colors
    public static func dynamicGradient(accentColor: Color) -> MeshGradient {
        let hsl = accentColor.toHSL()
        
        // Select color palette based on hue
        let colors = getColorPalette(for: hsl.hue, saturation: hsl.saturation, lightness: hsl.lightness)
        
        // Create randomized 4x4 mesh grid with palette colors
        var colorPool = [accentColor, accentColor, accentColor] + colors + colors
        let gridColors = (0..<16).map { _ in
            colorPool.randomElement() ?? accentColor
        }
        
        return MeshGradient(
            width: 4,
            height: 4,
            points: [
                .init(0.0, 0.0), .init(0.33, 0.0), .init(0.67, 0.0), .init(1.0, 0.0),
                .init(0.0, 0.33), .init(0.33, 0.33), .init(0.67, 0.33), .init(1.0, 0.33),
                .init(0.0, 0.67), .init(0.33, 0.67), .init(0.67, 0.67), .init(1.0, 0.67),
                .init(0.0, 1.0), .init(0.33, 1.0), .init(0.67, 1.0), .init(1.0, 1.0)
            ],
            colors: gridColors
        )
    }
    
    /// Selects a curated color palette based on the hue range
    private static func getColorPalette(for hue: Double, saturation: Double, lightness: Double) -> [Color] {
        switch hue {
        case 0..<30: // Red-Orange
            return [
                Color.fromHSL(hue: 10, saturation: saturation * 0.9, lightness: lightness * 1.1),
                Color.fromHSL(hue: 340, saturation: saturation * 0.95, lightness: lightness * 1.05),
                Color.fromHSL(hue: 25, saturation: saturation * 0.92, lightness: lightness * 0.95),
                Color.fromHSL(hue: 355, saturation: saturation * 0.88, lightness: lightness * 0.98),
                Color.fromHSL(hue: 15, saturation: saturation * 0.85, lightness: lightness * 1.02)
            ]
        case 30..<90: // Orange-Yellow
            return [
                Color.fromHSL(hue: 50, saturation: saturation * 0.9, lightness: lightness * 1.08),
                Color.fromHSL(hue: 65, saturation: saturation * 0.88, lightness: lightness * 1.05),
                Color.fromHSL(hue: 35, saturation: saturation * 0.92, lightness: lightness * 0.97),
                Color.fromHSL(hue: 75, saturation: saturation * 0.85, lightness: lightness * 1.03),
                Color.fromHSL(hue: 40, saturation: saturation * 0.9, lightness: lightness * 0.95)
            ]
        case 90..<150: // Yellow-Green
            return [
                Color.fromHSL(hue: 110, saturation: saturation * 0.88, lightness: lightness * 1.06),
                Color.fromHSL(hue: 95, saturation: saturation * 0.92, lightness: lightness * 1.04),
                Color.fromHSL(hue: 130, saturation: saturation * 0.9, lightness: lightness * 0.96),
                Color.fromHSL(hue: 85, saturation: saturation * 0.85, lightness: lightness * 1.02),
                Color.fromHSL(hue: 120, saturation: saturation * 0.87, lightness: lightness * 0.98)
            ]
        case 150..<210: // Green-Cyan
            return [
                Color.fromHSL(hue: 170, saturation: saturation * 0.9, lightness: lightness * 1.07),
                Color.fromHSL(hue: 185, saturation: saturation * 0.88, lightness: lightness * 1.04),
                Color.fromHSL(hue: 160, saturation: saturation * 0.92, lightness: lightness * 0.97),
                Color.fromHSL(hue: 195, saturation: saturation * 0.85, lightness: lightness * 1.02),
                Color.fromHSL(hue: 175, saturation: saturation * 0.87, lightness: lightness * 0.95)
            ]
        case 210..<270: // Cyan-Blue
            return [
                Color.fromHSL(hue: 225, saturation: saturation * 0.92, lightness: lightness * 1.06),
                Color.fromHSL(hue: 240, saturation: saturation * 0.9, lightness: lightness * 1.04),
                Color.fromHSL(hue: 215, saturation: saturation * 0.88, lightness: lightness * 0.97),
                Color.fromHSL(hue: 250, saturation: saturation * 0.85, lightness: lightness * 1.02),
                Color.fromHSL(hue: 230, saturation: saturation * 0.87, lightness: lightness * 0.96)
            ]
        case 270..<330: // Blue-Purple
            return [
                Color.fromHSL(hue: 285, saturation: saturation * 0.9, lightness: lightness * 1.05),
                Color.fromHSL(hue: 300, saturation: saturation * 0.88, lightness: lightness * 1.06),
                Color.fromHSL(hue: 275, saturation: saturation * 0.92, lightness: lightness * 0.96),
                Color.fromHSL(hue: 310, saturation: saturation * 0.85, lightness: lightness * 1.03),
                Color.fromHSL(hue: 290, saturation: saturation * 0.87, lightness: lightness * 0.98)
            ]
        default: // Purple-Red (330-360)
            return [
                Color.fromHSL(hue: 345, saturation: saturation * 0.9, lightness: lightness * 1.05),
                Color.fromHSL(hue: 330, saturation: saturation * 0.92, lightness: lightness * 1.04),
                Color.fromHSL(hue: 355, saturation: saturation * 0.88, lightness: lightness * 0.97),
                Color.fromHSL(hue: 320, saturation: saturation * 0.85, lightness: lightness * 1.02),
                Color.fromHSL(hue: 340, saturation: saturation * 0.87, lightness: lightness * 0.96)
            ]
        }
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
