import SwiftUI

public struct ParallaxCarouselStyle {
    public struct Shadow {
        public var color: Color
        public var radius: CGFloat
        public var x: CGFloat
        public var y: CGFloat

        public init(color: Color = .black.opacity(0.3), radius: CGFloat = 9, x: CGFloat = 5, y: CGFloat = 10) {
            self.color = color
            self.radius = radius
            self.x = x
            self.y = y
        }
    }

    public var cardSpacing: CGFloat
    public var horizontalPadding: CGFloat
    public var cardWidthInset: CGFloat
    public var cornerRadius: CGFloat
    public var parallaxDistance: CGFloat
    public var unfocusedCardScale: CGFloat
    public var shadow: Shadow
    public var shadowSpace: CGFloat

    public init(
        cardSpacing: CGFloat = 5,
        horizontalPadding: CGFloat = 30,
        cardWidthInset: CGFloat = 85,
        cornerRadius: CGFloat = 15,
        parallaxDistance: CGFloat = 100,
        unfocusedCardScale: CGFloat = 0.95,
        shadow: Shadow = Shadow(),
        shadowSpace: CGFloat = 30
    ) {
        self.cardSpacing = cardSpacing
        self.horizontalPadding = horizontalPadding
        self.cardWidthInset = cardWidthInset
        self.cornerRadius = cornerRadius
        self.parallaxDistance = parallaxDistance
        self.unfocusedCardScale = unfocusedCardScale
        self.shadow = shadow
        self.shadowSpace = shadowSpace
    }
}
