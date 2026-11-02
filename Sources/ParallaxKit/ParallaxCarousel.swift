import SwiftUI

public struct ParallaxCarousel<Item: Identifiable, Background: View, Overlay: View>: View {
    private let items: [Item]
    private let style: ParallaxCarouselStyle
    private let background: (Item) -> Background
    private let overlay: (Item) -> Overlay

    public init(
        _ items: [Item],
        style: ParallaxCarouselStyle = ParallaxCarouselStyle(),
        @ViewBuilder background: @escaping (Item) -> Background,
        @ViewBuilder overlay: @escaping (Item) -> Overlay
    ) {
        self.items = items
        self.style = style
        self.background = background
        self.overlay = overlay
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: style.cardSpacing) {
                    ForEach(items) { item in
                        ParallaxCard(containerSize: geometry.size, style: style) {
                            background(item)
                        } overlay: {
                            overlay(item)
                        }
                    }
                }
                .padding(.horizontal, style.horizontalPadding)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        }
    }
}

public extension ParallaxCarousel where Overlay == EmptyView {
    init(
        _ items: [Item],
        style: ParallaxCarouselStyle = ParallaxCarouselStyle(),
        @ViewBuilder background: @escaping (Item) -> Background
    ) {
        self.init(items, style: style, background: background) { _ in
            EmptyView()
        }
    }
}

private struct PreviewCard: Identifiable {
    let id: Int
    let color: Color
}

#Preview {
    ParallaxCarousel([.blue, .orange, .green, .purple].enumerated().map { PreviewCard(id: $0.offset, color: $0.element) }) { card in
        LinearGradient(colors: [card.color, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
    } overlay: { card in
        Text("Card \(card.id + 1)")
            .font(.headline)
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }
    .frame(height: 250)
}
