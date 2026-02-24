// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PitchDeckAuthKit",
    defaultLocalization: "en",
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
        .package(path: "../PitchDeckAuthApiKit"),
        .package(path: "../PitchDeckCoreKit"),
        .package(url: "https://github.com/openid/AppAuth-iOS.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.15.0")
    ],
    targets: [
        .target(
            name: "PitchDeckAuthKit",
            dependencies: ["PitchDeckNavigationApiKit", "PitchDeckUIKit", "PitchDeckAuthApiKit", "PitchDeckCoreKit", .product(name: "AppAuth", package: "AppAuth-iOS")]
        ),
        .testTarget(
            name: "PitchDeckAuthKitTests",
            dependencies: [
                "PitchDeckAuthKit",
                "PitchDeckNavigationApiKit",
                "PitchDeckUIKit",
                "PitchDeckAuthApiKit",
                "PitchDeckCoreKit",
                .product(name: "AppAuth", package: "AppAuth-iOS"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
    ]
)
