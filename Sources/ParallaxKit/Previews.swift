#if DEBUG
import SwiftUI

struct ParallaxKitDemo: View {
    var body: some View {
        StretchyHeaderScrollView(
            title: "Explore the Alps",
            subtitle: "Pull, scroll and swipe to feel the parallax.",
            headerHeight: 440,
            cardColor: Color(.systemBackground),
            showsIndicators: false
        ) {
            DemoScenery(scenery: .dusk)
        } content: {
            DemoSection(title: "Summits", destinations: DemoDestination.summits)
            DemoSection(title: "Lakes", destinations: DemoDestination.lakes)
        }
        .background(Color(.systemBackground))
    }
}

private struct DemoSection: View {
    let title: String
    let destinations: [DemoDestination]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 30)

            ParallaxCarousel(destinations) { destination in
                DemoScenery(scenery: destination.scenery)
            } overlay: { destination in
                DemoCardCaption(destination: destination)
            }
            .frame(height: 260)
        }
        .padding(.bottom, 16)
    }
}

private struct DemoCardCaption: View {
    let destination: DemoDestination

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(destination.name)
                .font(.headline)
            Text(destination.region)
                .font(.subheadline)
                .opacity(0.85)
        }
        .foregroundStyle(.white)
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .background(alignment: .bottom) {
            LinearGradient(colors: [.clear, .black.opacity(0.55)], startPoint: .top, endPoint: .bottom)
                .frame(height: 110)
        }
    }
}

private struct DemoScenery: View {
    let scenery: Scenery

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(colors: scenery.sky, startPoint: .top, endPoint: .bottom)

            Circle()
                .fill(scenery.sun)
                .frame(width: 80, height: 80)
                .offset(x: 70)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 60)

            Ridge(peaks: Ridge.far)
                .fill(scenery.farMountains)

            Ridge(peaks: Ridge.near)
                .fill(scenery.nearMountains)
        }
        .clipped()
    }
}

private struct Ridge: Shape {
    let peaks: [CGPoint]

    static let far = [
        CGPoint(x: 0, y: 0.6), CGPoint(x: 0.16, y: 0.44), CGPoint(x: 0.3, y: 0.56), CGPoint(x: 0.5, y: 0.34),
        CGPoint(x: 0.68, y: 0.52), CGPoint(x: 0.84, y: 0.4), CGPoint(x: 1, y: 0.5)
    ]

    static let near = [
        CGPoint(x: 0, y: 0.78), CGPoint(x: 0.22, y: 0.62), CGPoint(x: 0.4, y: 0.74), CGPoint(x: 0.62, y: 0.58),
        CGPoint(x: 0.82, y: 0.72), CGPoint(x: 1, y: 0.64)
    ]

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            for peak in peaks {
                path.addLine(to: CGPoint(x: rect.minX + peak.x * rect.width, y: rect.minY + peak.y * rect.height))
            }
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

private struct Scenery {
    let sky: [Color]
    let sun: Color
    let farMountains: Color
    let nearMountains: Color

    static let dusk = Scenery(
        sky: [Color(red: 0.16, green: 0.13, blue: 0.38), Color(red: 0.93, green: 0.45, blue: 0.42), Color(red: 1, green: 0.78, blue: 0.55)],
        sun: Color(red: 1, green: 0.9, blue: 0.7),
        farMountains: Color(red: 0.45, green: 0.25, blue: 0.45),
        nearMountains: Color(red: 0.2, green: 0.12, blue: 0.3)
    )

    static let morning = Scenery(
        sky: [Color(red: 0.35, green: 0.62, blue: 0.95), Color(red: 0.75, green: 0.9, blue: 1)],
        sun: Color(red: 1, green: 0.95, blue: 0.75),
        farMountains: Color(red: 0.55, green: 0.68, blue: 0.85),
        nearMountains: Color(red: 0.2, green: 0.36, blue: 0.55)
    )

    static let noon = Scenery(
        sky: [Color(red: 0.1, green: 0.55, blue: 0.75), Color(red: 0.55, green: 0.88, blue: 0.85)],
        sun: .white,
        farMountains: Color(red: 0.4, green: 0.7, blue: 0.62),
        nearMountains: Color(red: 0.1, green: 0.4, blue: 0.38)
    )

    static let sunset = Scenery(
        sky: [Color(red: 0.98, green: 0.45, blue: 0.3), Color(red: 1, green: 0.8, blue: 0.4)],
        sun: Color(red: 1, green: 0.95, blue: 0.8),
        farMountains: Color(red: 0.8, green: 0.35, blue: 0.3),
        nearMountains: Color(red: 0.45, green: 0.15, blue: 0.2)
    )

    static let night = Scenery(
        sky: [Color(red: 0.03, green: 0.05, blue: 0.18), Color(red: 0.15, green: 0.2, blue: 0.45)],
        sun: Color(red: 0.92, green: 0.92, blue: 1),
        farMountains: Color(red: 0.2, green: 0.25, blue: 0.5),
        nearMountains: Color(red: 0.06, green: 0.08, blue: 0.22)
    )

    static let mist = Scenery(
        sky: [Color(red: 0.6, green: 0.55, blue: 0.85), Color(red: 0.95, green: 0.8, blue: 0.9)],
        sun: Color(red: 1, green: 0.97, blue: 0.95),
        farMountains: Color(red: 0.7, green: 0.6, blue: 0.85),
        nearMountains: Color(red: 0.38, green: 0.3, blue: 0.6)
    )
}

private struct DemoDestination: Identifiable {
    let id = UUID()
    let name: String
    let region: String
    let scenery: Scenery

    static let summits = [
        DemoDestination(name: "Matterhorn", region: "Zermatt, Switzerland", scenery: .morning),
        DemoDestination(name: "Mont Blanc", region: "Chamonix, France", scenery: .sunset),
        DemoDestination(name: "Eiger", region: "Grindelwald, Switzerland", scenery: .night),
        DemoDestination(name: "Dolomites", region: "South Tyrol, Italy", scenery: .mist)
    ]

    static let lakes = [
        DemoDestination(name: "Lake Geneva", region: "Lausanne, Switzerland", scenery: .noon),
        DemoDestination(name: "Lake Como", region: "Lombardy, Italy", scenery: .dusk),
        DemoDestination(name: "Lac d'Annecy", region: "Haute-Savoie, France", scenery: .morning)
    ]
}

#Preview("Demo") {
    ParallaxKitDemo()
}
#endif
