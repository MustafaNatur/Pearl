// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MindMap",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "MindMap",
            targets: ["MindMap"]
        ),
    ],
    dependencies: [
        .package(name: "SharedModels", path: "../SHaredModels")
    ],
    targets: [
        .target(
            name: "MindMap",
            dependencies: [
                "SharedModels",
            ]
        ),
    ]
)
