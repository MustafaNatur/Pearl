// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedModels",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]),
    ],
    targets: [
        .target(name: "SharedModels"),
    ]
)
