// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PitchDeckNavigationApiKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PitchDeckNavigationApiKit",
            targets: ["PitchDeckNavigationApiKit"]
        ),
    ],
    targets: [
        .target(
            name: "PitchDeckNavigationApiKit"
        ),
    ]
)
