// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "psql-kit",
    platforms: [
        .macOS(.v10_15), .iOS(.v13)
    ],
    products: [
        .library(name: "PSQLKit", targets: ["PSQLKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/postgres-kit.git", from: "2.0.0")
    ],
    targets: [
        .target(name: "PSQLKit", dependencies: [
            .product(name: "FluentKit", package: "fluent-kit"),
            .product(name: "PostgresKit", package: "postgres-kit"),
        ]),
        .testTarget(name: "PSQLKitTests", dependencies: [
            .target(name: "PSQLKit"),
            .product(name: "FluentBenchmark", package: "fluent-kit")
        ])
    ]
)
