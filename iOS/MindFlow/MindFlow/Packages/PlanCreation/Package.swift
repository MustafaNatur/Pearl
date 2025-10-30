// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlanCreation",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "PlanCreation",
            targets: ["PlanCreation"]),
    ],
    dependencies: [
        .package(name: "SharedModels", path: "../SharedModels"),
        .package(name: "UIToolBox", path: "../UIToolBox"),
    ],
    targets: [
        .target(
            name: "PlanCreation",
            dependencies: [
                "SharedModels",
                "UIToolBox",
            ]
        ),
    ]
)
