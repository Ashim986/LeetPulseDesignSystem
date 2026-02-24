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
        ),
        .library(
            name: "LeetPulseDesignSystemCore",
            targets: ["LeetPulseDesignSystemCore"]
        ),
        .library(
            name: "LeetPulseDesignSystemState",
            targets: ["LeetPulseDesignSystemState"]
        ),
        .library(
            name: "LeetPulseDesignSystemComponents",
            targets: ["LeetPulseDesignSystemComponents"]
        )
    ],
    targets: [
        .target(
            name: "LeetPulseDesignSystemCore"
        ),
        .target(
            name: "LeetPulseDesignSystemState",
            dependencies: ["LeetPulseDesignSystemCore"]
        ),
        .target(
            name: "LeetPulseDesignSystemComponents",
            dependencies: ["LeetPulseDesignSystemCore", "LeetPulseDesignSystemState"]
        ),
        .target(
            name: "LeetPulseDesignSystem",
            dependencies: [
                "LeetPulseDesignSystemCore",
                "LeetPulseDesignSystemState",
                "LeetPulseDesignSystemComponents"
            ]
        ),
        .testTarget(
            name: "LeetPulseDesignSystemCoreTests",
            dependencies: ["LeetPulseDesignSystemCore"]
        ),
        .testTarget(
            name: "LeetPulseDesignSystemStateTests",
            dependencies: ["LeetPulseDesignSystemState"]
        ),
        .testTarget(
            name: "LeetPulseDesignSystemComponentsTests",
            dependencies: ["LeetPulseDesignSystemComponents"]
        )
    ]
)
