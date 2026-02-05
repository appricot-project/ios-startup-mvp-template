// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PitchDeckCabinetApiKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PitchDeckCabinetApiKit",
            targets: ["PitchDeckCabinetApiKit"]
        ),
    ],
    dependencies: [
        .package(path: "../PitchDeckMainApiKit")
    ],
    targets: [
        .target(
            name: "PitchDeckCabinetApiKit",
            dependencies: [
                .product(name: "PitchDeckMainApiKit", package: "PitchDeckMainApiKit")
            ],
            resources: [.process("Resources")]
        ),
    ]
)
