// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RMHTTP",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RMHTTP",
            targets: ["RMHTTP"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RMHTTP",
            dependencies: []),
    ]
)
