// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DigitizingVivariumsFoundation",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        // Main umbrella library that re-exports all public APIs
        .library(
            name: "DigitizingVivariumsFoundation",
            targets: ["DigitizingVivariumsFoundation"]
        ),
        // Granular module libraries for specific functionality
        .library(
            name: "DVFCore",
            targets: ["DVFCore"]
        ),
        .library(
            name: "DVFDatabase",
            targets: ["DVFDatabase"]
        ),
        .library(
            name: "DVFAuthentication",
            targets: ["DVFAuthentication"]
        ),
        .library(
            name: "DVFUI",
            targets: ["DVFUI"]
        )
    ],
    dependencies: [
        // Firebase dependencies with pinned versions for stability
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.20.0"),
        // SwiftUI dependencies for enhanced UI components
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
        // Testing dependencies
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.16.0")
    ],
    targets: [
        // Main umbrella target that re-exports all modules
        .target(
            name: "DigitizingVivariumsFoundation",
            dependencies: [
                "DVFCore",
                "DVFDatabase", 
                "DVFAuthentication",
                "DVFUI"
            ],
            path: "Sources/DigitizingVivariumsFoundation"
        ),
        
        // Core module - foundation data models and protocols
        .target(
            name: "DVFCore",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ],
            path: "Sources/DVFCore",
            resources: [
                .process("Resources")
            ]
        ),
        
        // Database module - Firebase integration and data persistence
        .target(
            name: "DVFDatabase",
            dependencies: [
                "DVFCore",
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk")
            ],
            path: "Sources/DVFDatabase"
        ),
        
        // Authentication module - user management and security
        .target(
            name: "DVFAuthentication",
            dependencies: [
                "DVFCore",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ],
            path: "Sources/DVFAuthentication"
        ),
        
        // UI module - SwiftUI components and theming
        .target(
            name: "DVFUI",
            dependencies: [
                "DVFCore",
                "DVFDatabase",
                "DVFAuthentication"
            ],
            path: "Sources/DVFUI",
            resources: [
                .process("Resources")
            ]
        ),
        
        // Test targets
        .testTarget(
            name: "DigitizingVivariumsFoundationTests",
            dependencies: [
                "DigitizingVivariumsFoundation",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/DigitizingVivariumsFoundationTests"
        ),
        
        .testTarget(
            name: "DVFCoreTests",
            dependencies: [
                "DVFCore",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/DVFCoreTests"
        ),
        
        .testTarget(
            name: "DVFDatabaseTests",
            dependencies: [
                "DVFDatabase",
                "DVFCore",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/DVFDatabaseTests"
        ),
        
        .testTarget(
            name: "DVFAuthenticationTests",
            dependencies: [
                "DVFAuthentication",
                "DVFCore",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/DVFAuthenticationTests"
        ),
        
        .testTarget(
            name: "DVFUITests",
            dependencies: [
                "DVFUI",
                "DVFCore",
                "DVFDatabase",
                "DVFAuthentication",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/DVFUITests"
        )
    ]
)
