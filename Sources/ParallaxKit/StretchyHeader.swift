import SwiftUI

public struct StretchyHeader<Background: View, Overlay: View>: View {
    private let parallaxIntensity: CGFloat
    private let pinsToTop: Bool
    private let background: Background
    private let overlay: (CGFloat) -> Overlay

    public init(
        parallaxIntensity: CGFloat = 0.5,
        pinsToTop: Bool = true,
        @ViewBuilder background: () -> Background,
        @ViewBuilder overlay: @escaping (_ scrollOffset: CGFloat) -> Overlay
    ) {
        self.parallaxIntensity = parallaxIntensity
        self.pinsToTop = pinsToTop
        self.background = background()
        self.overlay = overlay
    }

    public var body: some View {
        GeometryReader { geometry in
            let scrollOffset = geometry.frame(in: .scrollView).minY

            background
                .frame(width: geometry.size.width, height: stretchedHeight(geometry.size.height, scrollOffset: scrollOffset))
                .offset(y: verticalOffset(for: scrollOffset))
                .overlay(alignment: .bottomLeading) {
                    overlay(scrollOffset)
                }
        }
    }

    private func stretchedHeight(_ height: CGFloat, scrollOffset: CGFloat) -> CGFloat {
        height + max(0, scrollOffset)
    }

    private func verticalOffset(for scrollOffset: CGFloat) -> CGFloat {
        if scrollOffset < 0 {
            return -scrollOffset * parallaxIntensity
        }
        return pinsToTop ? -scrollOffset : 0
    }
}

public extension StretchyHeader where Overlay == EmptyView {
    init(
        parallaxIntensity: CGFloat = 0.5,
        pinsToTop: Bool = true,
        @ViewBuilder background: () -> Background
    ) {
        self.init(parallaxIntensity: parallaxIntensity, pinsToTop: pinsToTop, background: background) { _ in
            EmptyView()
        }
    }
}

public extension StretchyHeader where Overlay == StretchyHeaderTitle {
    init(
        title: String,
        subtitle: String = "",
        parallaxIntensity: CGFloat = 0.5,
        pinsToTop: Bool = true,
        @ViewBuilder background: () -> Background
    ) {
        self.init(parallaxIntensity: parallaxIntensity, pinsToTop: pinsToTop, background: background) { scrollOffset in
            StretchyHeaderTitle(title: title, subtitle: subtitle, scrollOffset: scrollOffset)
        }
    }
}

#Preview {
    ScrollView {
        StretchyHeader(title: "Fly the future", subtitle: "Pull down to stretch, scroll up to fade.") {
            LinearGradient(colors: [.blue, .teal], startPoint: .top, endPoint: .bottom)
        }
        .frame(height: 400)

        ForEach(0..<20) { index in
            Text("Row \(index)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
    }
    .ignoresSafeArea(edges: .top)
}
