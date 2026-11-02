import SwiftUI

public struct StretchyHeaderScrollView<Background: View, HeaderOverlay: View, Content: View, Footer: View>: View {
    private let headerHeight: CGFloat
    private let overlap: CGFloat
    private let cornerRadius: CGFloat
    private let cardColor: Color
    private let cardMinHeight: CGFloat
    private let contentTopPadding: CGFloat
    private let parallaxIntensity: CGFloat
    private let pinsToTop: Bool
    private let showsIndicators: Bool
    private let background: Background
    private let headerOverlay: (CGFloat) -> HeaderOverlay
    private let content: Content
    private let footer: Footer

    public init(
        headerHeight: CGFloat = 400,
        overlap: CGFloat = 50,
        cornerRadius: CGFloat = 34,
        cardColor: Color = Color(.systemBackground),
        cardMinHeight: CGFloat = 0,
        contentTopPadding: CGFloat = 34,
        parallaxIntensity: CGFloat = 0.5,
        pinsToTop: Bool = true,
        showsIndicators: Bool = true,
        @ViewBuilder background: () -> Background,
        @ViewBuilder headerOverlay: @escaping (_ scrollOffset: CGFloat) -> HeaderOverlay,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.headerHeight = headerHeight
        self.overlap = overlap
        self.cornerRadius = cornerRadius
        self.cardColor = cardColor
        self.cardMinHeight = cardMinHeight
        self.contentTopPadding = contentTopPadding
        self.parallaxIntensity = parallaxIntensity
        self.pinsToTop = pinsToTop
        self.showsIndicators = showsIndicators
        self.background = background()
        self.headerOverlay = headerOverlay
        self.content = content()
        self.footer = footer()
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            StretchyHeader(parallaxIntensity: parallaxIntensity, pinsToTop: pinsToTop) {
                background
            } overlay: { scrollOffset in
                headerOverlay(scrollOffset)
            }
            .frame(height: headerHeight)

            Spacer(minLength: -overlap)

            card

            footer
        }
        .ignoresSafeArea(edges: .top)
    }

    private var card: some View {
        VStack(spacing: 0) {
            content
        }
        .padding(.top, contentTopPadding)
        .frame(maxWidth: .infinity, minHeight: cardMinHeight, alignment: .top)
        .background(cardColor, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

public extension StretchyHeaderScrollView where Footer == EmptyView {
    init(
        headerHeight: CGFloat = 400,
        overlap: CGFloat = 50,
        cornerRadius: CGFloat = 34,
        cardColor: Color = Color(.systemBackground),
        cardMinHeight: CGFloat = 0,
        contentTopPadding: CGFloat = 34,
        parallaxIntensity: CGFloat = 0.5,
        pinsToTop: Bool = true,
        showsIndicators: Bool = true,
        @ViewBuilder background: () -> Background,
        @ViewBuilder headerOverlay: @escaping (_ scrollOffset: CGFloat) -> HeaderOverlay,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            headerHeight: headerHeight,
            overlap: overlap,
            cornerRadius: cornerRadius,
            cardColor: cardColor,
            cardMinHeight: cardMinHeight,
            contentTopPadding: contentTopPadding,
            parallaxIntensity: parallaxIntensity,
            pinsToTop: pinsToTop,
            showsIndicators: showsIndicators,
            background: background,
            headerOverlay: headerOverlay,
            content: content
        ) {
            EmptyView()
        }
    }
}

public extension StretchyHeaderScrollView where HeaderOverlay == StretchyHeaderTitle {
    init(
        title: String,
        subtitle: String = "",
        headerHeight: CGFloat = 400,
        overlap: CGFloat = 50,
        cornerRadius: CGFloat = 34,
        cardColor: Color = Color(.systemBackground),
        cardMinHeight: CGFloat = 0,
        contentTopPadding: CGFloat = 34,
        parallaxIntensity: CGFloat = 0.5,
        pinsToTop: Bool = true,
        showsIndicators: Bool = true,
        @ViewBuilder background: () -> Background,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(
            headerHeight: headerHeight,
            overlap: overlap,
            cornerRadius: cornerRadius,
            cardColor: cardColor,
            cardMinHeight: cardMinHeight,
            contentTopPadding: contentTopPadding,
            parallaxIntensity: parallaxIntensity,
            pinsToTop: pinsToTop,
            showsIndicators: showsIndicators,
            background: background,
            headerOverlay: { scrollOffset in
                StretchyHeaderTitle(title: title, subtitle: subtitle, scrollOffset: scrollOffset)
            },
            content: content,
            footer: footer
        )
    }
}

public extension StretchyHeaderScrollView where HeaderOverlay == StretchyHeaderTitle, Footer == EmptyView {
    init(
        title: String,
        subtitle: String = "",
        headerHeight: CGFloat = 400,
        overlap: CGFloat = 50,
        cornerRadius: CGFloat = 34,
        cardColor: Color = Color(.systemBackground),
        cardMinHeight: CGFloat = 0,
        contentTopPadding: CGFloat = 34,
        parallaxIntensity: CGFloat = 0.5,
        pinsToTop: Bool = true,
        showsIndicators: Bool = true,
        @ViewBuilder background: () -> Background,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            headerHeight: headerHeight,
            overlap: overlap,
            cornerRadius: cornerRadius,
            cardColor: cardColor,
            cardMinHeight: cardMinHeight,
            contentTopPadding: contentTopPadding,
            parallaxIntensity: parallaxIntensity,
            pinsToTop: pinsToTop,
            showsIndicators: showsIndicators,
            background: background,
            content: content
        ) {
            EmptyView()
        }
    }
}

#Preview {
    StretchyHeaderScrollView(title: "Fly the future", subtitle: "Content slides over the header.") {
        LinearGradient(colors: [.blue, .teal], startPoint: .top, endPoint: .bottom)
    } content: {
        ForEach(0..<20) { index in
            Text("Row \(index)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
    }
    .background(Color(.secondarySystemBackground))
}
