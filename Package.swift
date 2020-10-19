// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PSQLKit",
    platforms: [
        .macOS(.v10_15), .iOS(.v13)
    ],
    products: [
        .library(name: "PSQLKit", targets: ["PSQLKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0")
    ],
    targets: [
        .target(name: "PSQLKit", dependencies: [
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
        ]),
        .testTarget(name: "PSQLKitTests", dependencies: [
            .target(name: "PSQLKit"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
        ])
    ]
)
