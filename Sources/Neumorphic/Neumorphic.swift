
import Foundation
import SwiftUI
import CoreGraphics

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

public struct Bg : ViewModifier {
    public init(color: CGColor) {
        self.color = color
    }
    
    private var color: CGColor
    public func body(content: Content) -> some View {
        ZStack {
            Color(cgColor: color)
            content
        }
    }
}

public struct NeumorphicBg : ViewModifier {
    private var dark: Bool
    
    public init(dark: Bool) {
        self.dark = dark
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            (dark ? Color.nNeutralDark : Color.nNeutral)
            content
        }
    }
}


public enum size { case small, medium, large }


public struct Neumorphic<S: Shape>: ViewModifier {
    private var shape: S
    private var sizeScale = 1.0
    
    private var height: Double = 0.0
    
    private var blendMode = BlendMode.normal
    private var color: CGColor = CGColor.cgNeutral
    private var shadowColor: Color = Color.nShadow
    private var neutralColor: Color = Color.nNeutral
    private var highlightColor: Color = Color.nHighlight
    
    private var innerColor: CGColor = CGColor.clear
    private var innerShadowColor: Color = Color.nShadow
    private var innerNeutralColor: Color = Color.nNeutral
    private var innerHighlightColor: Color = Color.nHighlight
    
    private var highlightOpacity = 0.6
    private var highlightRadius = 0.0
    private var highlightOffset = 0.0
    
    private var shadowOpacity = 0.2
    private var shadowRadius = 0.0
    private var shadowOffset = 0.0
    
    private var insetDepth = 0.0
    private var insetWidth = 0.0
    private var insetShadowOpacity = 0.5
    private var insetHighlightOpacity = 0.6
    private var lipOpacity = 0.0
    
    public init(height: Double, shape: S, color: CGColor = CGColor.cgNeutral, size: size = .medium, innerColor: CGColor = CGColor.clear) {
        
        self.init(height: height, shape: shape)
        self.shadowColor = Color(cgColor: color.shadow())
        self.neutralColor = Color(cgColor: color)
        self.highlightColor = Color(cgColor: color.highlight())
        self.color = color
        if(size == .small) { sizeScale = 0.75 }
        if(size == .large) { sizeScale = 1.25}
        if(innerColor == CGColor.clear) {
            self.innerColor = self.color
            self.innerShadowColor = self.shadowColor
            self.innerNeutralColor = self.neutralColor
            self.innerHighlightColor = self.highlightColor
        } else {
            self.innerColor = innerColor
            self.innerShadowColor = Color(cgColor: innerColor.shadow())
            self.innerNeutralColor = Color(cgColor: innerColor)
            self.innerHighlightColor = Color(cgColor: innerColor.highlight())
        }
    }
    
    public init(height: Double, shape: S) {
        self.height = height
        if(height > 1) { self.height = 1 }
        else if(height < -1) { self.height = -1 }
        self.shape = shape
        let absHeight = abs(self.height)
        
        if(self.height >= 0) {
            self.lipOpacity = 0.0
            self.highlightRadius = linearInterpolate(x: 0.0, y: 6, t: absHeight) * sizeScale
            self.highlightOffset = -linearInterpolate(x: 0.0, y: 10, t: absHeight) * sizeScale
            self.highlightOpacity = linearInterpolate(x: 0.0, y: 0.9, t: absHeight * 2.0)
            
            self.shadowRadius = linearInterpolate(x: 0.0, y: 8, t: absHeight) * sizeScale
            self.shadowOffset = linearInterpolate(x: 0.0, y: 10, t: absHeight) * sizeScale
            self.shadowOpacity = linearInterpolate(x: 0.0, y: 0.7, t: absHeight * 1.0)
        } else {
            self.highlightRadius = linearInterpolate(x: 0.0, y: 9, t: absHeight) * sizeScale
            self.highlightOffset = -linearInterpolate(x: 0.0, y: 8.0, t: absHeight) * sizeScale
            self.highlightOpacity = linearInterpolate(x: 0.0, y: 0.5, t: absHeight * 3.0)
            
            self.shadowRadius = linearInterpolate(x: 0.0, y: 9, t: absHeight) * sizeScale
            self.shadowOffset = linearInterpolate(x: 0.0, y: 8.0, t: absHeight) * sizeScale
            self.shadowOpacity = linearInterpolate(x: 0.0, y: 0.3, t: absHeight * 3.0)
            
            self.insetDepth = linearInterpolate(x: 0.0, y: 4.0, t: absHeight) * sizeScale
            self.insetWidth = 6 * sizeScale
            self.insetShadowOpacity = linearInterpolate(x: 0.0, y: 1.0, t: absHeight)
            self.insetHighlightOpacity = linearInterpolate(x: 0.0, y: 1.0, t: absHeight)
            self.lipOpacity = linearInterpolate(x: 0.0, y: 1, t: absHeight)
        }
    }
    
    private func innerShadow(_ content: Neumorphic.Content) -> some View {
        return GeometryReader { geo in
            ZStack {
                ZStack {
                    self.shape.stroke(self.innerShadowColor.opacity(self.insetShadowOpacity), lineWidth: CGFloat(self.insetWidth * 1.5))
                    }.blur(radius: 10).offset(x: CGFloat(self.insetDepth), y: CGFloat(self.insetDepth)).mask(self.shape.fill(LinearGradient(Color.black, Color.clear)))
                ZStack {
                     self.shape.stroke(self.innerHighlightColor.opacity(self.insetHighlightOpacity), lineWidth: CGFloat(self.insetWidth * 2))
                }.blur(radius: 10).offset(x: -CGFloat(self.insetDepth), y: -CGFloat(self.insetDepth)).mask(self.shape.fill(LinearGradient(Color.clear, Color.black)))
            }
        }
    }
    
    private func backingShadow(_ content: Neumorphic.Content) -> some View {
        return GeometryReader { geo in
            Group {
                self.shape.fill(self.innerNeutralColor)
                .shadow(color: self.shadowColor.opacity(self.shadowOpacity), radius: CGFloat(self.shadowRadius), x: CGFloat(self.shadowOffset), y: CGFloat(self.shadowOffset))
                .shadow(color: self.highlightColor.opacity(self.highlightOpacity), radius: CGFloat(self.highlightRadius), x: CGFloat(self.highlightOffset), y: CGFloat(self.highlightOffset))
            }
        }
    }
    
    private func lip(_ content: Neumorphic.Content) -> some View {
        return GeometryReader { geo in
            self.shape.stroke(self.neutralColor.opacity(self.lipOpacity), lineWidth: 2.0)
        }
    }
    
    public func body(content: Content) -> some View {
        // Border
        // Inner shadows
        // Content
        // Filled background
        // Outer shadows
        ZStack {
            //Shape fill backing
            backingShadow(content)
            //Inner shadow
            if(self.height < 0) {
                innerShadow(content)
            }
            //Content layer
            content
            //Top border
            lip(content)
        }
    }
}

extension View {
    
    public func neumorphic<S : Shape>(_ content: S, height: Double, color: CGColor = CGColor.cgNeutral, size: size = .medium, innerColor: CGColor = CGColor.clear) -> some View {
        
        modifier(Neumorphic(height: height, shape: content, color: color, size: size, innerColor: innerColor))
        
    }
    
    public func n_bg(dark: Bool = false) -> some View {
        self.modifier(NeumorphicBg(dark: dark))
    }
    
    public func bg(color: CGColor = CGColor.cgNeutral) -> some View {
        self.modifier(Bg(color: color))
    }

}

public struct NeumorphicButtonStyle<S: Shape> : ButtonStyle {
    var shape: S
    var color: CGColor
    var innerColor: CGColor
    public init(_ shape: S, color: CGColor, innerColor: CGColor) {
        self.shape = shape
        self.color = color
        self.innerColor = innerColor
    }
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.padding().scaleEffect(configuration.isPressed ? 0.96 : 1).neumorphic(shape, height: configuration.isPressed ? -0.9 : 0.9, color: self.color, innerColor: self.innerColor).animation(.spring(response: 0.2, dampingFraction: 0.8, blendDuration: 1.0))
    }
}

extension Button {
    public func neumorphicButtonStyle<S : Shape>(_ content: S, color: CGColor = CGColor.cgNeutral, innerColor: CGColor = CGColor.clear) -> some View {
        self.buttonStyle(NeumorphicButtonStyle(content, color: color, innerColor: innerColor))
    }
    
}
