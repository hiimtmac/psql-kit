// swift-tools-version: 6.0
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
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.49.0"),
        .package(url: "https://github.com/vapor/sql-kit.git", from: "3.32.0"),
        .package(url: "https://github.com/vapor/postgres-kit.git", from: "2.13.0")
    ],
    targets: [
        .target(
            name: "PSQLKit",
            dependencies: [
                .product(name: "FluentKit", package: "fluent-kit"),
                .product(name: "SQLKit", package: "sql-kit"),
                .product(name: "PostgresKit", package: "postgres-kit"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny")
            ]
        ),
        .target(
            name: "FluentPSQLKit",
            dependencies: [
                .target(name: "PSQLKit"),
                .product(name: "FluentKit", package: "fluent-kit")
            ]
        ),
        .testTarget(name: "PSQLKitTests", dependencies: [
            .target(name: "PSQLKit"),
            .product(name: "PostgresKit", package: "postgres-kit"),
            .product(name: "FluentBenchmark", package: "fluent-kit"),
        ])
    ]
)
