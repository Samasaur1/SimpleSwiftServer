// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "SimpleSwiftServer",
    products: [
        .executable(name: "server", targets: ["SimpleSwiftServer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Samasaur1/SwiftIP", from: "1.0.0"),
        .package(url: "https://github.com/httpswift/swifter", .exact("1.4.5")),
    ],
    targets: [
        .target(name: "SimpleSwiftServer", dependencies: ["SwiftIP", "Swifter"]),
    ]
)
