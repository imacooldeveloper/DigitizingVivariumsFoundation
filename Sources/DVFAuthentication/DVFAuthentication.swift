// The Swift Programming Language
// https://docs.swift.org/swift-book

/// DVFAuthentication - User authentication and multi-tenant security
/// for the DigitizingVivariumsFoundation package.
///
/// This module provides user authentication, role-based access control,
/// and multi-tenant security for the vivarium digitization system.

// Re-export all public APIs from authentication submodules
@_exported import Foundation
import DVFCore
import FirebaseAuth

// Authentication services (to be implemented)
// @_exported import class DVFAuthentication.DVFAuthenticationService
// @_exported import class DVFAuthentication.DVFAuthService
// @_exported import class DVFAuthentication.DVFUserManager

// Authentication models (to be implemented)
// @_exported import struct DVFAuthentication.DVFUser
// @_exported import struct DVFAuthentication.DVFRole

// Authentication protocols (to be implemented)
// @_exported import protocol DVFAuthentication.DVFAuthProvider
// @_exported import protocol DVFAuthentication.DVFUserProvider

// Authentication errors (to be implemented)
// @_exported import enum DVFAuthentication.DVFAuthenticationError

/// Placeholder for future authentication implementation
public struct DVFAuthenticationPlaceholder {
    public static let message = "Authentication module implementation coming soon"
}

/// Main entry point for the DVFAuthentication module
public struct DVFAuthentication {
    
    /// Shared authentication instance
    public static let shared = DVFAuthentication()
    
    /// Firebase Auth instance
    public let auth: Auth
    
    /// Authentication configuration
    public var configuration: AuthenticationConfiguration
    
    private init() {
        self.auth = Auth.auth()
        self.configuration = AuthenticationConfiguration()
    }
    
    /// Initialize authentication with custom configuration
    /// - Parameter config: Authentication configuration settings
    public init(configuration config: AuthenticationConfiguration) {
        self.auth = Auth.auth()
        self.configuration = config
    }
    
    /// Configure authentication settings
    /// - Parameter config: New configuration settings
    public mutating func configure(with config: AuthenticationConfiguration) {
        self.configuration = config
    }
    
    /// Reset authentication to default settings
    public mutating func reset() {
        self.configuration = AuthenticationConfiguration()
    }
}

/// Authentication configuration settings
public struct AuthenticationConfiguration {
    /// Enable email/password authentication
    public var enableEmailPassword: Bool = true
    
    /// Enable Google Sign-In
    public var enableGoogleSignIn: Bool = true
    
    /// Enable Apple Sign-In
    public var enableAppleSignIn: Bool = true
    
    /// Require email verification
    public var requireEmailVerification: Bool = true
    
    /// Minimum password length
    public var minimumPasswordLength: Int = 8
    
    /// Session timeout in seconds
    public var sessionTimeout: TimeInterval = 3600 // 1 hour
    
    public init() {}
}

/// Authentication service for user management
public class DVFAuthenticationService {
    private let authentication: DVFAuthentication
    
    public init(authentication: DVFAuthentication = .shared) {
        self.authentication = authentication
    }
    
    /// Current authenticated user
    public var currentUser: User? {
        return authentication.auth.currentUser
    }
    
    /// Check if user is authenticated
    public var isAuthenticated: Bool {
        return currentUser != nil
    }
    
    /// Sign in with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Authentication result
    public func signIn(email: String, password: String) async throws -> AuthDataResult {
        return try await authentication.auth.signIn(withEmail: email, password: password)
    }
    
    /// Sign up with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Authentication result
    public func signUp(email: String, password: String) async throws -> AuthDataResult {
        return try await authentication.auth.createUser(withEmail: email, password: password)
    }
    
    /// Sign out current user
    public func signOut() throws {
        try authentication.auth.signOut()
    }
    
    /// Send password reset email
    /// - Parameter email: Email address to send reset to
    public func sendPasswordReset(email: String) async throws {
        try await authentication.auth.sendPasswordReset(withEmail: email)
    }
    
    /// Update user password
    /// - Parameter newPassword: New password
    public func updatePassword(_ newPassword: String) async throws {
        guard let user = currentUser else {
            throw AuthenticationError.noAuthenticatedUser
        }
        try await user.updatePassword(to: newPassword)
    }
    
    /// Update user email
    /// - Parameter newEmail: New email address
    public func updateEmail(_ newEmail: String) async throws {
        guard let user = currentUser else {
            throw AuthenticationError.noAuthenticatedUser
        }
        try await user.updateEmail(to: newEmail)
    }
    
    /// Delete current user account
    public func deleteAccount() async throws {
        guard let user = currentUser else {
            throw AuthenticationError.noAuthenticatedUser
        }
        try await user.delete()
    }
}

/// Authentication errors
public enum AuthenticationError: LocalizedError {
    case noAuthenticatedUser
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case networkError
    
    public var errorDescription: String? {
        switch self {
        case .noAuthenticatedUser:
            return "No authenticated user found"
        case .invalidCredentials:
            return "Invalid email or password"
        case .emailAlreadyInUse:
            return "Email address is already in use"
        case .weakPassword:
            return "Password is too weak"
        case .networkError:
            return "Network connection error"
        }
    }
} 