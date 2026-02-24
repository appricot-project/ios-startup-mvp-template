// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PitchDeckMainKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PitchDeckMainKit",
            targets: ["PitchDeckMainKit"]
        ),
    ],
    dependencies: [
        .package(path: "../PitchDeckNavigationApiKit"),
        .package(path: "../PitchDeckCoreKit"),
        .package(path: "../PitchDeckUIKit"),
        .package(path: "../PitchDeckMainApiKit"),
        .package(path: "../PitchDeckStartupApi"),
        .package(
           url: "https://github.com/pointfreeco/swift-snapshot-testing",
           from: "1.18.7"
         ),
    ],
    targets: [
        .target(
            name: "PitchDeckMainKit",
            dependencies: ["PitchDeckNavigationApiKit", "PitchDeckCoreKit", "PitchDeckUIKit", "PitchDeckMainApiKit", "PitchDeckStartupApi"],
        ),
        .testTarget(
            name: "PitchDeckMainKitTests",
            dependencies: [
                "PitchDeckMainKit", 
                "PitchDeckMainApiKit",
                "PitchDeckNavigationApiKit",
                "PitchDeckCoreKit", 
                "PitchDeckUIKit",
                "PitchDeckStartupApi",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
    ]
)
