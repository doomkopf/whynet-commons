// swift-tools-version: 6.3.3
import PackageDescription

let package = Package(
    name: "WhynetCommons",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "WhynetCommons",
            targets: ["WhynetCommons"],
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WhynetCommons",
            dependencies: [],
            swiftSettings: swiftSettings,
        ),
        .testTarget(
            name: "UnitTests",
            dependencies: ["WhynetCommons"],
            swiftSettings: swiftSettings,
        ),
    ])

var swiftSettings: [SwiftSetting] {
    [
        .enableExperimentalFeature("StrictConcurrency")
    ]
}
