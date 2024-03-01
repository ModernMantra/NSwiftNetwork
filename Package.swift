// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NSwiftNetwork",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "NSwiftNetwork",
            targets: [
                "NSwiftNetwork"
            ]),
    ],
    targets: [
        .target(
            name: "NSwiftNetwork"),
        .testTarget(
            name: "NSwiftNetworkTests",
            dependencies: [
                "NSwiftNetwork"
            ]),
    ]
)
