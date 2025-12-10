// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PitchDeckNavigationKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PitchDeckNavigationKit",
            targets: ["PitchDeckNavigationKit"]
        ),
    ],
    dependencies: [
        .package(path: "../PitchDeckRootKit"),
    ],
    targets: [
        .target(
            name: "PitchDeckNavigationKit",
            dependencies: ["PitchDeckRootKit"],
        ),
    ]
)
