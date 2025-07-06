// The Swift Programming Language
// https://docs.swift.org/swift-book

/// DigitizingVivariumsFoundation - A comprehensive Swift Package Manager foundation
/// for digitizing vivarium management systems.
///
/// This package provides a modular architecture for building vivarium digitization
/// applications with support for multi-tenant facilities, real-time data synchronization,
/// and comprehensive user management.
///
/// ## Overview
///
/// The package is organized into four main modules:
///
/// - **DVFCore**: Foundation data models, protocols, and configuration systems
/// - **DVFDatabase**: Firebase Firestore integration and data persistence
/// - **DVFAuthentication**: User authentication and multi-tenant security
/// - **DVFUI**: SwiftUI components and theming system
///
/// ## Quick Start
///
/// ```swift
/// import DigitizingVivariumsFoundation
///
/// // Initialize the foundation with your Firebase configuration
/// let foundation = DVFFoundation.shared
/// await foundation.configure(with: firebaseConfig)
///
/// // Access facility management
/// let facilityManager = foundation.facilityManager
/// let facilities = await facilityManager.fetchFacilities()
///
/// // Access authentication
/// let authService = foundation.authenticationService
/// let user = await authService.signIn(email: "user@example.com", password: "password")
/// ```
///
/// ## Features
///
/// - **Multi-tenant Architecture**: Secure isolation between different facilities
/// - **Real-time Synchronization**: Live updates across all connected clients
/// - **Comprehensive UI Components**: Pre-built SwiftUI components for common vivarium operations
/// - **Flexible Configuration**: Adaptable to different facility types and requirements
/// - **Offline Support**: Full functionality without network connectivity
/// - **Security First**: Role-based access control and audit logging
///
/// ## Requirements
///
/// - iOS 16.0+ / macOS 13.0+ / watchOS 9.0+ / tvOS 16.0+
/// - Swift 6.0+
/// - Firebase project with Firestore and Authentication enabled
///
/// ## Installation
///
/// Add this package to your Xcode project or Package.swift dependencies:
///
/// ```swift
/// .package(url: "https://github.com/your-org/DigitizingVivariumsFoundation.git", from: "1.0.0")
/// ```
///
/// ## Documentation
///
/// For detailed documentation, see the [API Reference](https://your-docs-url.com)
/// and [Getting Started Guide](https://your-docs-url.com/getting-started).
///
/// ## License
///
/// This package is licensed under the MIT License. See the LICENSE file for details.
///
/// ## Contributing
///
/// We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md)
/// for details on how to submit pull requests and report issues.

// Re-export all public APIs from the modular components
@_exported import DVFCore
@_exported import DVFDatabase
@_exported import DVFAuthentication
@_exported import DVFUI

/// The main entry point for the DigitizingVivariumsFoundation package.
///
/// This class provides a centralized interface for configuring and accessing
/// all foundation services and components.
public final class DVFFoundation: @unchecked Sendable {
    
    /// Shared instance for global access to foundation services
    public static let shared = DVFFoundation()
    
    /// Core configuration and data management
    public let core: DVFCoreService
    
    /// Database operations and persistence
    public let database: DVFDatabase.DVFDatabaseService
    
    /// Authentication and user management
    public let authentication: DVFAuthentication.DVFAuthenticationService
    
    /// UI components and theming
    public let ui: DVFUIService
    
    private init() {
        self.core = DVFCoreService()
        self.database = DVFDatabase.DVFDatabaseService()
        self.authentication = DVFAuthentication.DVFAuthenticationService()
        self.ui = DVFUIService()
    }
    
    /// Configure the foundation with Firebase configuration
    /// - Parameter config: Firebase configuration options
    public func configure(with config: DVFFirebaseConfiguration) async throws {
        try await core.configure(with: config)
        try await database.configure(with: config)
        try await authentication.configure(with: config)
        try await ui.configure(with: config)
    }
    
    /// Reset the foundation to its initial state
    public func reset() async {
        await core.reset()
        await database.reset()
        await authentication.reset()
        await ui.reset()
    }
}

// Convenience accessors for backward compatibility
public extension DVFFoundation {
    var facilityManager: DVFFacilityManager { core.facilityManager }
    var configurationManager: DVFConfigurationManager { core.configurationManager }
    var dataManager: DVFDataManager? { nil } // Placeholder, update if implemented
    var authService: DVFAuthService? { nil } // Placeholder, update if implemented
    var userManager: DVFUserManager? { nil } // Placeholder, update if implemented
    var themeManager: DVFThemeManager { ui.themeManager }
    var componentLibrary: DVFComponentLibrary { ui.componentLibrary }
}
