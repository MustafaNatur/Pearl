//
//  Color+Extensions.swift
//  PlansScreen
//
//  Created by Mustafa on 23.06.2025.
//


import SwiftUI
import UIKit

extension UIColor {
    public convenience init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255,
            blue: CGFloat(hex & 0x0000FF) / 255,
            alpha: alpha
        )
    }

    public convenience init(hex hexString: String, alpha: CGFloat = 1) {
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        let hex = UInt32(bitPattern: scanner.scanInt32(representation: .hexadecimal) ?? 0)

        self.init(hex: hex, alpha: alpha)
    }
}

extension Color {
    public init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(UIColor(hex: hex, alpha: alpha))
    }

    public init(hex hexString: String, alpha: CGFloat = 1) {
        self.init(UIColor(hex: hexString, alpha: alpha))
    }
}
