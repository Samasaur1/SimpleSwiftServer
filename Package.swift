// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "SimpleSwiftServer",
    products: [
        .executable(name: "server", targets: ["SimpleSwiftServer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Samasaur1/SwiftIP", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.2.0"),
        .package(url: "https://github.com/Samasaur1/swifter", .branch("simpleswiftserver-version")),
    ],
    targets: [
        .target(name: "SimpleSwiftServer", dependencies: ["ArgumentParser", "SwiftIP", "Swifter"]),
    ]
)
