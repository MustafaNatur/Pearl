// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlansScreen",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "PlansScreen",
            targets: ["PlansScreen"]),
    ],
    dependencies: [
        .package(name: "SharedModels", path: "../SharedModels"),
        .package(name: "UIToolBox", path: "../UIToolBox"),
    ],
    targets: [
        .target(
            name: "PlansScreen",
            dependencies: [
                "SharedModels",
                "UIToolBox",
            ]
        ),
    ]
)
