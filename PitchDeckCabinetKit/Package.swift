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
        .package(url: "https://github.com/auth0/JWTDecode.swift", from: "2.6.0")
    ],
    targets: [
        .target(
            name: "PitchDeckCabinetKit",
            dependencies: ["PitchDeckNavigationApiKit", "PitchDeckMainApiKit", "PitchDeckCabinetApiKit", "PitchDeckCoreKit", "PitchDeckUIKit", .product(name: "JWTDecode", package: "JWTDecode.swift")],
            resources: [.process("Resources")]
        )
    ]
)
