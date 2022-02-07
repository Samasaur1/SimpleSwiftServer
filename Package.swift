// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "SimpleSwiftServer",
    products: [
        .executable(name: "server", targets: ["SimpleSwiftServer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Samasaur1/SwiftIP", .branch("fix-linux")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.2.0"),
        .package(url: "https://github.com/httpswift/swifter", .exact("1.4.5")),
    ],
    targets: [
        .target(name: "SimpleSwiftServer", dependencies: ["ArgumentParser", "SwiftIP", "Swifter"]),
    ]
)
