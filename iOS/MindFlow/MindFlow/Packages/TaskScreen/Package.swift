// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TaskScreen",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "TaskScreen",
            targets: ["TaskScreen"]),
    ],
    dependencies: [
        .package(name: "SharedModels", path: "../SharedModels"),
        .package(name: "PlanRepository", path: "../PlanRepository"),
        .package(name: "UIToolBox", path: "../UIToolBox"),
    ],
    targets: [
        .target(
            name: "TaskScreen",
            dependencies: [
                "SharedModels",
                "PlanRepository",
                "UIToolBox",
            ]
        ),
    ]
)
