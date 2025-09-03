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
        .package(name: "PlanCreation", path: "../PlanCreation"),
        .package(name: "PlanRepository", path: "../PlanRepository"),
        .package(name: "MindMap", path: "../MindMap"),
    ],
    targets: [
        .target(
            name: "PlansScreen",
            dependencies: [
                "SharedModels",
                "UIToolBox",
                "PlanCreation",
                "PlanRepository",
                "MindMap",
            ]
        ),
    ]
)
