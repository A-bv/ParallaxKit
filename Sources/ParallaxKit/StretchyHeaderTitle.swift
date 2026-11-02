import SwiftUI

public struct StretchyHeaderTitle: View {
    private let title: String
    private let subtitle: String
    private let scrollOffset: CGFloat
    private let fadeOutDistance: CGFloat

    public init(title: String, subtitle: String = "", scrollOffset: CGFloat, fadeOutDistance: CGFloat = 100) {
        self.title = title
        self.subtitle = subtitle
        self.scrollOffset = scrollOffset
        self.fadeOutDistance = fadeOutDistance
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
            }
        }
        .foregroundStyle(.white)
        .opacity(opacity)
        .padding()
        .padding(.bottom, 60)
        .padding(.leading, 20)
    }

    private var opacity: Double {
        max(0, min(1, 1 - abs(scrollOffset) / fadeOutDistance))
    }
}
