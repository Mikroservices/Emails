// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Emails",
    platforms: [
       .macOS(.v10_15)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        
        // 📖 Apple logger handler.
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
        
        // 📘 Custom logger handlers.
        .package(url: "https://github.com/Mikroservices/ExtendedLogging.git", from: "1.0.0"),

        // 🐞 Custom error middleware for Vapor.
        .package(url: "https://github.com/Mikroservices/ExtendedError.git", from: "2.0.0"),

        // 📒 Library provides mechanism for reading configuration files.
        .package(url: "https://github.com/Mikroservices/ExtendedConfiguration.git", from: "1.0.0"),
        
        // ✉️ SMTP protocol support for the Vapor web framework.
        .package(url: "https://github.com/Mikroservices/Smtp.git", from: "2.1.4")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "ExtendedError", package: "ExtendedError"),
                .product(name: "ExtendedLogging", package: "ExtendedLogging"),
                .product(name: "ExtendedConfiguration", package: "ExtendedConfiguration"),
                .product(name: "Smtp", package: "Smtp")
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor")
        ])
    ]
)
