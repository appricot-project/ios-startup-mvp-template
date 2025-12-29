// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PitchDeckAuthKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PitchDeckAuthKit",
            targets: ["PitchDeckAuthKit"]
        ),
    ],
    dependencies: [
        .package(path: "../PitchDeckNavigationApiKit"),
        .package(path: "../PitchDeckUIKit"),

    ],
    targets: [
        .target(
            name: "PitchDeckAuthKit",
            dependencies: ["PitchDeckNavigationApiKit", "PitchDeckUIKit"]
        ),
    ]
)
