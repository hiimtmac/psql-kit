// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "psql-kit",
    platforms: [
        .macOS(.v14), .iOS(.v17),
    ],
    products: [
        .library(name: "PSQLKit", targets: ["PSQLKit"]),
        .library(name: "FluentPSQLKit", targets: ["FluentPSQLKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.49.0"),
        .package(url: "https://github.com/vapor/sql-kit.git", from: "3.32.0"),
        .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.20.0"),
        .package(url: "https://github.com/vapor/postgres-kit.git", from: "2.13.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.1")
    ],
    targets: [
        .macro(
            name: "PSQLKitMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "PSQLKit",
            dependencies: [
                .target(name: "PSQLKitMacros"),
                .product(name: "SQLKit", package: "sql-kit"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny")
            ]
        ),
        .target(
            name: "FluentPSQLKit",
            dependencies: [
                .target(name: "PSQLKit"),
                .target(name: "PSQLKitMacros"),
                .product(name: "FluentKit", package: "fluent-kit"),
                .product(name: "PostgresKit", package: "postgres-kit")
            ],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny")
            ]
        ),
        .testTarget(name: "PSQLKitTests", dependencies: [
            .target(name: "PSQLKit"),
            .product(name: "PostgresKit", package: "postgres-kit"),
            .product(name: "FluentBenchmark", package: "fluent-kit"),
        ]),
        .testTarget(name: "FluentPSQLKitTests", dependencies: [
            .target(name: "FluentPSQLKit"),
            .product(name: "PostgresKit", package: "postgres-kit"),
            .product(name: "FluentBenchmark", package: "fluent-kit"),
            .product(name: "FluentKit", package: "fluent-kit"),
        ]),
        .testTarget(
            name: "PSQLKitMacroTests",
            dependencies: [
                .target(name: "PSQLKitMacros"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
