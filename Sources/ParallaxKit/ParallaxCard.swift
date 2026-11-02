import SwiftUI

struct ParallaxCard<Background: View, Overlay: View>: View {
    let containerSize: CGSize
    let style: ParallaxCarouselStyle
    @ViewBuilder let background: () -> Background
    @ViewBuilder let overlay: () -> Overlay

    private var cardWidth: CGFloat {
        containerSize.width - style.cardWidthInset
    }

    var body: some View {
        GeometryReader { geometry in
            background()
                .scaleEffect(style.imageScale)
                .offset(x: -parallaxShift(for: geometry) + style.imageOffset)
                .frame(width: cardWidth, height: containerSize.height - style.shadowSpace)
                .overlay {
                    overlay()
                }
                .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
                .shadow(color: style.shadow.color, radius: style.shadow.radius, x: style.shadow.x, y: style.shadow.y)
        }
        .frame(width: cardWidth, height: containerSize.height)
        .scrollTransition(.interactive, axis: .horizontal) { [unfocusedCardScale = style.unfocusedCardScale] view, phase in
            view.scaleEffect(phase.isIdentity ? 1 : unfocusedCardScale)
        }
    }

    private func parallaxShift(for geometry: GeometryProxy) -> CGFloat {
        min(geometry.frame(in: .global).minX, geometry.size.width) * style.parallaxFactor
    }
}
