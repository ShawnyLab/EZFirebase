// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EZFirebase",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "EZFirebase",
            targets: ["EZFirebase"]),
        .library(name: "EZFirestore", targets: ["EZFirestore"]),
        .library(name: "EZStorage", targets: ["EZStorage"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.18.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "EZFirebase"),
        .target(name: "EZFirestore"),
        .target(name: "EZStorage"),
        .testTarget(
            name: "EZFirebaseTests",
            dependencies: ["EZFirebase"]),
    ]
)
