// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftUIFocusGuide",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v14),
        .tvOS(.v14)
    ],
    products: [
        .library(
            name: "SwiftUIFocusGuide",
            targets: ["SwiftUIFocusGuide"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftUIFocusGuide",
            dependencies: []
        ),
    ]
)
