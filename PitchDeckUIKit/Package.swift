// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
    name: "PitchDeckUIKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PitchDeckUIKit",
            targets: ["PitchDeckUIKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-spm.git", .upToNextMajor(from: "4.5.0")),
    ],
    targets: [
        .target(
            name: "PitchDeckUIKit",
            dependencies: [.product(name: "Lottie", package: "lottie-spm")]
        )
    ]
)
