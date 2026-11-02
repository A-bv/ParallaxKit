// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ParallaxKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "ParallaxKit", targets: ["ParallaxKit"])
    ],
    targets: [
        .target(name: "ParallaxKit")
    ]
)
