//
//  Extension+Color.swift
//  HEX2HSL
//
//  Created by Wayne Dahlberg on 7/15/24.
//

import SwiftUI

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        self.init(red: Double((rgb & 0xFF0000) >> 16) / 255.0,
                  green: Double((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: Double(rgb & 0x0000FF) / 255.0)
    }
    
    func toHex() -> String? {
        let uic = NSColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let hex = String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        return hex
    }
    
    func toHSL() -> (h: Double, s: Double, l: Double) {
        let color = NSColor(self)
        guard let rgbColor = color.usingColorSpace(.sRGB) else {
            return (0, 0, 0)
        }
        
        let r = rgbColor.redComponent
        let g = rgbColor.greenComponent
        let b = rgbColor.blueComponent
        
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)
        
        var h: Double = 0
        var s: Double = 0
        let l = (max + min) / 2
        
        if max != min {
            let d = max - min
            s = l > 0.5 ? d / (2 - max - min) : d / (max + min)
            
            switch max {
            case r: h = (g - b) / d + (g < b ? 6 : 0)
            case g: h = (b - r) / d + 2
            default: h = (r - g) / d + 4
            }
            
            h /= 6
        }
        
        return (h * 360, s, l)
    }
}
