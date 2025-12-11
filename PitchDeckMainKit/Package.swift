// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PitchDeckMainKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PitchDeckMainKit",
            targets: ["PitchDeckMainKit"]
        ),
    ],
    dependencies: [
        .package(path: "../PitchDeckNavigationApiKit"),
    ],
    targets: [
        .target(
            name: "PitchDeckMainKit",
            dependencies: ["PitchDeckNavigationApiKit"]
        )
    ]
)
