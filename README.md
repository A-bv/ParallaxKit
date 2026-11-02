# ParallaxKit

SwiftUI building blocks for parallax effects on iOS 17+:

- **`StretchyHeader`**: a header that stretches when you pull down, scrolls with a parallax effect, and can show a fading title.
- **`ParallaxCarousel`**: a horizontal carousel of cards whose image moves in parallax, with snapping and a scale effect on the cards that are not in focus.

## Installation

In Xcode: **File → Add Package Dependencies…**, then paste the repository URL:

```
https://github.com/A-bv/ParallaxKit
```

Or in `Package.swift`:

```swift
.package(url: "https://github.com/A-bv/ParallaxKit", from: "1.0.0")
```

## StretchyHeader

Place it at the top of a `ScrollView` and give it a height.

```swift
import ParallaxKit

ScrollView {
    StretchyHeader(title: "Fly the future", subtitle: "Book a seat in seconds.") {
        Image("hero")
            .resizable()
            .scaledToFill()
    }
    .frame(height: 450)

    content
}
.ignoresSafeArea(edges: .top)
```

Without a title:

```swift
StretchyHeader {
    Image("hero").resizable().scaledToFill()
}
```

With your own overlay. The closure receives the scroll offset, so you can animate anything with it:

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

`StretchyHeaderTitle` is the title view used by `StretchyHeader(title:subtitle:)`. You can reuse it in a custom overlay and change `fadeOutDistance`.

## ParallaxCarousel

Give it any `Identifiable` items, the background of each card, and optionally an overlay. Set its height with `.frame(height:)`.

```swift
import ParallaxKit

ParallaxCarousel(trips) { trip in
    Image(trip.imageName)
        .resizable()
        .scaledToFill()
} overlay: { trip in
    Text(trip.title)
        .font(.headline)
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
}
.frame(height: 250)
```

Customize the look with `ParallaxCarouselStyle`:

```swift
ParallaxCarousel(trips, style: ParallaxCarouselStyle(cornerRadius: 24, unfocusedCardScale: 0.9)) { trip in
    Image(trip.imageName).resizable().scaledToFill()
}
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
