// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "psql-kit",
    platforms: [
        .macOS(.v14), .iOS(.v17),
    ],
    products: [
        .library(name: "PSQLKit", targets: ["PSQLKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.47.0"),
        .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.20.0"),
        .package(url: "https://github.com/vapor/postgres-kit.git", from: "2.12.0"),
    ],
    targets: [
        .target(
            name: "PSQLKit",
            dependencies: [
                .product(name: "FluentKit", package: "fluent-kit"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(name: "PSQLKitTests", dependencies: [
            .target(name: "PSQLKit"),
            .product(name: "PostgresKit", package: "postgres-kit"),
            .product(name: "FluentBenchmark", package: "fluent-kit"),
        ])
    ]
)
