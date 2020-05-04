//
//  File.swift
//
//
//  Created by Keenan Rebera on 5/1/20.
//

import Foundation
import SwiftUI
import CoreGraphics

@available(OSX 10.15, *)
extension Color {
    public static let nNeutral = Color(cgColor: CGColor.cgNeutral)
    public static let nHighlight = Color(cgColor: CGColor.cgHighlight)
    public static let nShadow = Color(cgColor: CGColor.cgShadow)
    public static let nAlternate = Color(cgColor: CGColor.cgAlternate)
    
    public static let nNeutralDark = Color(cgColor: CGColor.cgNeutralDark)
    public static let nHighlightDark = Color(cgColor: CGColor.cgHighlightDark)
    public static let nShadowDark = Color(cgColor: CGColor.cgShadowDark)
    public static let nAlternateDark = Color(cgColor: CGColor.cgAlternateDark)
    
    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        assert(red >= 0 && red <= 1.0, "Invalid red component")
        assert(green >= 0 && green <= 1.0, "Invalid green component")
        assert(blue >= 0 && blue <= 1.0, "Invalid blue component")
        self.init(.sRGB, red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
    }
    
    public init(cgColor: CGColor) {
        let comps = cgColor.rgba;
        self.init(.sRGB, red: Double(comps.red), green: Double(comps.green), blue: Double(comps.blue), opacity: Double(comps.alpha))
    }
}

public func colorForHex(rgb: Int, alpha: CGFloat = 1.0) -> CGColor{
    let red: CGFloat = CGFloat((rgb >> 16) & 0xFF) / 255.0
    let green: CGFloat = CGFloat((rgb >> 8) & 0xFF) / 255.0
    let blue: CGFloat = CGFloat(rgb & 0xFF) / 255.0
    return CGColor(srgbRed: red, green: green, blue: blue, alpha: alpha)
}

extension CGColor {
    public static let cgNeutral = colorForHex(rgb: 0xECF0F3)
    public static let cgHighlight = colorForHex(rgb: 0xF9FBFB)
    public static let cgShadow = colorForHex(rgb: 0xD1D9E6)
    public static let cgAlternate = colorForHex(rgb: 0x7b808c)
    
    public static let cgNeutralDark = colorForHex(rgb: 0x303135)
    public static let cgHighlightDark = colorForHex(rgb: 0x3e3f46)
    public static let cgShadowDark = colorForHex(rgb: 0x232323)
    public static let cgAlternateDark = colorForHex(rgb: 0xe8e8e8)
    
    public static let clear = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        if let comps = components {
            if(numberOfComponents == 4) {
                return(red: comps[0], green: comps[1], blue: comps[2], alpha: CGFloat(1.0))
            } else {
                return(red: comps[0], green: comps[1], blue: comps[2], alpha: comps[3])
            }
        }
        return(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(1.0))
    }
    
    public func applyColorDifference(neutral: CGColor, move: CGColor, to color: CGColor) -> CGColor {
        let neutralComps = neutral.rgba
        let highlightComps = move.rgba
        let inputComps = color.rgba
        
        return CGColor(srgbRed: inputComps.red + (highlightComps.red - neutralComps.red), green: inputComps.green + (highlightComps.green - neutralComps.green), blue: inputComps.blue + (highlightComps.blue - neutralComps.blue), alpha: 1.0)
    }
    
    public func value() -> CGFloat{
        let comps = self.rgba
        return max(comps.red, comps.green, comps.blue)
    }
    
    public func highlight() -> CGColor {
        if(self.value() > 0.5) {
            return applyColorDifference(neutral: CGColor.cgNeutral, move: CGColor.cgHighlight, to: self)
        } else {
            return applyColorDifference(neutral: CGColor.cgNeutralDark, move: CGColor.cgHighlightDark, to: self)
        }
    }
    
    public func shadow() -> CGColor {
        if(self.value() > 0.8) {
            return applyColorDifference(neutral: CGColor.cgNeutral, move: CGColor.cgShadow, to: self)
        } else {
            return applyColorDifference(neutral: CGColor.cgNeutralDark, move: CGColor.cgShadowDark, to: self)
        }
    }
    
    public func alternate() -> CGColor {
        if(self.value() > 0.8) {
            return applyColorDifference(neutral: CGColor.cgNeutral, move: CGColor.cgAlternate, to: self)
        } else {
            return applyColorDifference(neutral: CGColor.cgNeutralDark, move: CGColor.cgAlternateDark, to: self)
        }
    }
    
    //Val between -1 and 1
    public func interpolate(val : Double, other : CGColor) -> CGColor {
        //Backwards linear interpolation
        let otherComps = other.rgba
       
        return CGColor(
            srgbRed: CGFloat(linearInterpolate(x: Double(self.rgba.red), y: Double(otherComps.red), t: abs(val))),
            green: CGFloat(linearInterpolate(x: Double(self.rgba.green), y: Double(otherComps.green), t: abs(val))),
            blue: CGFloat(linearInterpolate(x: Double(self.rgba.blue), y: Double(otherComps.blue), t: abs(val))),
            alpha: CGFloat(linearInterpolate(x: Double(self.rgba.alpha), y: Double(otherComps.alpha), t: abs(val))))
    }
}
