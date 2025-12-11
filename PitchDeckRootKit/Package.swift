// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PitchDeckRootKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PitchDeckRootKit",
            targets: ["PitchDeckRootKit"]
        ),
    ],
    dependencies: [
        .package(path: "../PitchDeckMainKit"),
        .package(path: "../PitchDeckCabinetKit"),
    ],
    targets: [
        .target(
            name: "PitchDeckRootKit",
            dependencies: ["PitchDeckMainKit", "PitchDeckCabinetKit"]
        ),
    ]
)
