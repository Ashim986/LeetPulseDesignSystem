// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LeetPulseDesignSystem",
    platforms: [
        .macOS(.v14),
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "LeetPulseDesignSystem",
            targets: ["LeetPulseDesignSystem"]
        )
    ],
    targets: [
        .target(
            name: "LeetPulseDesignSystem"
        ),
        .testTarget(
            name: "LeetPulseDesignSystemTests",
            dependencies: ["LeetPulseDesignSystem"]
        )
    ]
)
