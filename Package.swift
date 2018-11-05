// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "SimpleSwiftServer",
    products: [
        .executable(name: "server", targets: ["SimpleSwiftServer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/httpswift/swifter.git", from: "1.4.5"),
        .package(url: "git@github.com:Samasaur1/SwiftIP.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "SimpleSwiftServer", dependencies: ["Swifter", "SwiftIP"]),
    ]
)
