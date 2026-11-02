import SwiftUI

struct ParallaxCard<Background: View, Overlay: View>: View {
    let containerSize: CGSize
    let style: ParallaxCarouselStyle
    @ViewBuilder let background: () -> Background
    @ViewBuilder let overlay: () -> Overlay

    private var cardWidth: CGFloat {
        containerSize.width - style.cardWidthInset
    }

    private var cardHeight: CGFloat {
        containerSize.height - style.shadowSpace
    }

    var body: some View {
        GeometryReader { geometry in
            background()
                .frame(width: cardWidth + 2 * style.parallaxDistance, height: cardHeight)
                .offset(x: parallaxShift(for: geometry))
                .frame(width: cardWidth, height: cardHeight)
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
        let distanceFromRest = geometry.frame(in: .scrollView(axis: .horizontal)).minX - style.horizontalPadding
        let progress = distanceFromRest / (cardWidth + style.cardSpacing)
        return -min(max(progress, -1), 1) * style.parallaxDistance
    }
}
