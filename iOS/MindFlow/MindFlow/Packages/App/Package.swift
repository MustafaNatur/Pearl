// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "App",
            targets: ["App"]
        ),
    ],
    dependencies: [
        .package(name: "PlansScreen", path: "../PlansScreen"),
        .package(name: "MindAssistant", path: "../MindAssistant"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                "PlansScreen",
                "MindAssistant"
            ]
        ),
    ]
)
