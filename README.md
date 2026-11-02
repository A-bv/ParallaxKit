# ParallaxKit

Parallax for SwiftUI, the way travel and music apps do it: a header image that stretches when you pull down and drifts slower than the page when you scroll, a rounded card that slides over it, and a carousel whose pictures move inside their cards as you swipe.

![iOS 17+](https://img.shields.io/badge/iOS-17%2B-007AFF?logo=apple&logoColor=white)
![Swift 5.9](https://img.shields.io/badge/Swift-5.9-F05138?logo=swift&logoColor=white)
![SPM](https://img.shields.io/badge/SPM-compatible-success)
[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey)](LICENSE)

<p align="center">
  <img src=".github/demo.gif" alt="Pulling the header to stretch it, scrolling the card over it, then swiping a carousel whose images move in parallax" width="380">
</p>

*Pull to stretch, scroll to let the card slide over the header, swipe to move the pictures inside their cards. Every pixel above is drawn by the package's own preview, so you can play with it in Xcode.*

## Features

- **`StretchyHeaderScrollView`**: a whole screen in one view. Header, rounded card and content, ready to scroll.
- **`StretchyHeader`**: the header on its own, to drop into any `ScrollView`.
- **`ParallaxCarousel`**: a horizontal carousel that snaps to each card and zooms out the ones beside it.
- **Any view as content.** Headers and cards take a view, not an image name: photos, gradients, maps or video.
- **No dependencies, no setup.** Pure SwiftUI, a few hundred lines.

## Install

In Xcode, **File ▸ Add Package Dependencies…** and paste the URL:

```
https://github.com/A-bv/ParallaxKit
```

or declare it in `Package.swift`:

```swift
.package(url: "https://github.com/A-bv/ParallaxKit", from: "1.1.0")
```

## Try it

Open `Package.swift` in Xcode, then `Sources/ParallaxKit/Previews.swift`. The canvas runs the demo from the GIF: switch it to **Live** and pull, scroll and swipe.

## Usage

The whole screen from the GIF, in a dozen lines:

```swift
import ParallaxKit

struct ExploreView: View {
    var body: some View {
        StretchyHeaderScrollView(title: "Explore the Alps", subtitle: "Pull, scroll and swipe.") {
            Image("alps")
                .resizable()
                .scaledToFill()
        } content: {
            Text("Summits").font(.title2.bold())
            ParallaxCarousel(summits) { summit in
                Image(summit.photo)
                    .resizable()
                    .scaledToFill()
            } overlay: { summit in
                Text(summit.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
            .frame(height: 260)
        }
    }
}
```

### StretchyHeaderScrollView

A `StretchyHeader` at the top, then a rounded card that overlaps it and holds your content. Anything in `footer` goes after the card, on the page background.

```swift
StretchyHeaderScrollView(
    title: "Fly the future",
    subtitle: "Book a seat in seconds.",
    headerHeight: 450,
    cardColor: .white
) {
    Image("hero").resizable().scaledToFill()
} content: {
    Picker("Region", selection: $region) { … }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    ServicesList()
} footer: {
    AboutUs()
}
.background(.black)
```

The first element of `content` sits `contentTopPadding` below the rounded edge, so a picker, a logo or a title lines up the same way on every screen. Use `headerOverlay:` instead of `title:` to draw your own overlay; it receives the scroll offset.

| Parameter | Default | Effect |
|---|---|---|
| `headerHeight` | `400` | Height of the header at rest. |
| `overlap` | `50` | How far the card slides over the bottom of the header. |
| `cornerRadius` | `34` | Card corner radius. |
| `cardColor` | system background | Card color. |
| `cardMinHeight` | `0` | Minimum card height, useful while the content is loading. |
| `contentTopPadding` | `34` | Space between the rounded edge and the first element. |
| `parallaxIntensity`, `pinsToTop` | `0.5`, `true` | Passed to the header, see below. |
| `showsIndicators` | `true` | Shows the vertical scroll indicator. |

### StretchyHeader

The header alone. Put it at the top of a `ScrollView` and give it a height.

```swift
ScrollView {
    StretchyHeader(title: "Fly the future", subtitle: "Book a seat in seconds.") {
        Image("hero").resizable().scaledToFill()
    }
    .frame(height: 450)

    content
}
.ignoresSafeArea(edges: .top)
```

Leave out `title:` for a bare image, or pass an `overlay:` that reacts to the scroll offset:

```swift
StretchyHeader {
    Image("hero").resizable().scaledToFill()
} overlay: { scrollOffset in
    MyBadge()
        .opacity(scrollOffset < -80 ? 0 : 1)
}
```

| Parameter | Default | Effect |
|---|---|---|
| `parallaxIntensity` | `0.5` | How much slower the background moves when scrolling up. `0` scrolls normally, `1` keeps it still. |
| `pinsToTop` | `true` | Keeps the top of the image attached to the top of the screen when pulling down. |

`StretchyHeaderTitle` is the fading title used by `title:subtitle:`. Reuse it in your own overlay and tune `fadeOutDistance`.

### ParallaxCarousel

Give it any `Identifiable` items, the background of each card and, optionally, an overlay. Set its height with `.frame(height:)`, and its look with `ParallaxCarouselStyle`:

```swift
ParallaxCarousel(trips, style: ParallaxCarouselStyle(cornerRadius: 24, unfocusedCardScale: 0.9)) { trip in
    Image(trip.photo).resizable().scaledToFill()
}
.frame(height: 250)
```

| Property | Default | Effect |
|---|---|---|
| `cardSpacing` | `5` | Space between cards. |
| `horizontalPadding` | `30` | Space before the first and after the last card. |
| `cardWidthInset` | `85` | Card width is the carousel width minus this value, so the next card peeks in. |
| `cornerRadius` | `15` | Card corner radius. |
| `parallaxFactor` | `1` | Strength of the image movement inside the card. |
| `imageScale` | `1.08` | Zoom on the image, so its edges stay hidden while it moves. |
| `imageOffset` | `40` | Horizontal shift of the image at rest. |
| `unfocusedCardScale` | `0.95` | Scale of the cards that are not centered. |
| `shadow` | black 30 %, radius 9, x 5, y 10 | Card shadow. |
| `shadowSpace` | `30` | Space kept under the cards so the shadow is not cut. |

## How it works

The header reads its own position in the scroll view with a `GeometryReader`. Pulled down, it grows by the overscroll and stays pinned to the top; scrolled up, it moves back down by `parallaxIntensity` of the distance, so it lags behind the page. The carousel snaps with `scrollTargetBehavior(.viewAligned)`, shifts each picture by its card's horizontal position, and scales the side cards with `scrollTransition`.

## Layout

```text
Package.swift     ┐
Sources/          ┘  the library and its Xcode previews

README.md         ┐
LICENSE           ┘  docs

.github/          the demo GIF
```

## License

MIT. See [LICENSE](LICENSE).
