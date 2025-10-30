// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlanRepository",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "PlanRepository",
            targets: ["PlanRepository"]),
    ],
    dependencies: [
        .package(name: "SharedModels", path: "../SharedModels"),
    ],
    targets: [
        .target(
            name: "PlanRepository",
            dependencies: ["SharedModels"]
        ),
    ]
)
