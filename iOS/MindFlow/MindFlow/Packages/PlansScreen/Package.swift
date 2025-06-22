// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlansScreen",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "PlansScreen",
            targets: ["PlansScreen"]),
    ],
    targets: [
        .target(
            name: "PlansScreen"),

    ]
)
