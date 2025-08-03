// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlansScreen",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "PlansScreen",
            targets: ["PlansScreen"]),
    ],
    dependencies: [
        .package(name: "SharedModels", path: "../SharedModels"),
        .package(name: "UIToolBox", path: "../UIToolBox"),
        .package(name: "PlanCreationContextMenu", path: "../PlanCreationContextMenu"),
        .package(name: "PlanRepository", path: "../PlanRepository"),
    ],
    targets: [
        .target(
            name: "PlansScreen",
            dependencies: [
                "SharedModels",
                "UIToolBox",
                "PlanCreationContextMenu",
                "PlanRepository",
            ]
        ),
    ]
)
