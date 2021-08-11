// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Backend",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Backend",
            targets: ["Backend"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Backend",
            dependencies: []
        ),
        .testTarget(
            name: "BackendTests",
            dependencies: ["Backend"]
        ),
    ]
)
