// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PitchDeckCabinetKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PitchDeckCabinetKit",
            targets: ["PitchDeckCabinetKit"]
        ),
    ],
    dependencies: [
        .package(path: "../PitchDeckNavigationApiKit"),
    ],
    targets: [
        .target(
            name: "PitchDeckCabinetKit",
            dependencies: ["PitchDeckNavigationApiKit"],
        ),
    ]
)
