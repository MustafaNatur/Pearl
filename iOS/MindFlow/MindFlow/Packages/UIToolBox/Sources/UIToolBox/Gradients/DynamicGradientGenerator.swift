import SwiftUI

// MARK: - Dynamic Gradient Generator
extension LinearGradient {
    
    /// Generates a beautiful linear gradient with the given color as the main accent
    /// Creates soft complementary colors for a smooth multi-color gradient effect
    /// - Parameter accentColor: The main color to feature in the gradient
    /// - Returns: A LinearGradient with the accent color and soft complementary colors
    public static func dynamicGradient(accentColor: Color) -> LinearGradient {
        let hsl = accentColor.toHSL()
        
        // Generate soft complementary colors with subtle variations
        let softColor1 = Color.fromHSL(
            hue: (hsl.hue + 30).truncatingRemainder(dividingBy: 360), // Closer analogous color for softer transition
            saturation: max(hsl.saturation - 0.1, 0.4), // Slightly less saturated
            lightness: min(hsl.lightness + 0.1, 0.8)    // Slightly lighter
        )
        
        let softColor2 = Color.fromHSL(
            hue: (hsl.hue - 30 + 360).truncatingRemainder(dividingBy: 360), // Other side analogous color
            saturation: max(hsl.saturation - 0.15, 0.3), // Even less saturated for softness
            lightness: max(hsl.lightness - 0.1, 0.2)     // Slightly darker
        )
        
        // Use 4 colors for even smoother transitions
        let midColor = Color.fromHSL(
            hue: hsl.hue,
            saturation: max(hsl.saturation - 0.05, 0.3), // Very close to original
            lightness: hsl.lightness // Same lightness as original
        )
        
        return LinearGradient(
            colors: [softColor1, accentColor, midColor, softColor2],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Generates a dynamic gradient with the specified accent color
    /// - Parameter accentColor: The main color to feature in the gradient
    /// - Returns: A LinearGradient with the accent color and soft complementary colors
    public static func generate(accentColor: Color) -> LinearGradient {
        return dynamicGradient(accentColor: accentColor)
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
    
    /// Generates a soft dynamic gradient with this color as the accent
    public var dynamicGradient: LinearGradient {
        return LinearGradient.dynamicGradient(accentColor: self)
    }
    
    /// Generates a soft dynamic gradient with this color as the accent
    public var gradient: LinearGradient {
        return LinearGradient.generate(accentColor: self)
    }
}
