// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PitchDeckCabinetKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PitchDeckCabinetKit",
            targets: ["PitchDeckCabinetKit"]
        ),
    ],
    dependencies: [
        .package(path: "../PitchDeckNavigationApiKit"),
        .package(path: "../PitchDeckMainApiKit"),
        .package(path: "../PitchDeckCabinetApiKit"),
        .package(path: "../PitchDeckCoreKit"),
        .package(path: "../PitchDeckUIKit"),
        .package(path: "../PitchDeckAuthApiKit"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.15.0")
    ],
    targets: [
        .target(
            name: "PitchDeckCabinetKit",
            dependencies: ["PitchDeckNavigationApiKit", "PitchDeckMainApiKit", "PitchDeckCabinetApiKit", "PitchDeckCoreKit", "PitchDeckUIKit", "PitchDeckAuthApiKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "PitchDeckCabinetKitTests",
            dependencies: [
                "PitchDeckCabinetKit",
                "PitchDeckCabinetApiKit",
                "PitchDeckMainApiKit",
                "PitchDeckAuthApiKit",
                "PitchDeckUIKit",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests"
        )
    ]
)
