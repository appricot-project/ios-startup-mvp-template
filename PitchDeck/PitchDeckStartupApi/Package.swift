// swift-tools-version:6.1

import PackageDescription

let package = Package(
  name: "PitchDeckStartupApi",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
    .tvOS(.v15),
    .watchOS(.v8),
    .visionOS(.v1),
  ],
  products: [
    .library(name: "PitchDeckStartupApi", targets: ["PitchDeckStartupApi"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios", exact: "2.0.4"),
  ],
  targets: [
    .target(
      name: "PitchDeckStartupApi",
      dependencies: [
        .product(name: "ApolloAPI", package: "apollo-ios"),
      ],
      path: "./Sources"
    ),
  ],
  swiftLanguageModes: [.v6, .v5]
)
