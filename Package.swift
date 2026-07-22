// swift-tools-version: 6.0
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "talk-demo",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "DemoMacros", targets: ["DemoMacros"]),
        .executable(name: "DemoMacrosClient", targets: ["DemoMacrosClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.6.0"),
    ],
    targets: [
        .macro(
            name: "DemoMacrosMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(name: "DemoMacros", dependencies: ["DemoMacrosMacros"]),
        .executableTarget(name: "DemoMacrosClient", dependencies: ["DemoMacros"]),
        .testTarget(
            name: "DemoMacrosTests",
            dependencies: [
                "DemoMacrosMacros",
                .product(name: "MacroTesting", package: "swift-macro-testing"),
            ]
        ),
    ]
)
