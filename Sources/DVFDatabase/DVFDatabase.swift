// The Swift Programming Language
// https://docs.swift.org/swift-book

/// DVFDatabase - Firebase Firestore integration and data persistence
/// for the DigitizingVivariumsFoundation package.
///
/// This module provides database operations, real-time synchronization,
/// and data persistence for the vivarium digitization system.

// Re-export all public APIs from database submodules
@_exported import Foundation
import DVFCore
import FirebaseFirestore
import FirebaseFirestoreSwift

// Database services (to be implemented)
// @_exported import class DVFDatabase.DVFDatabaseService
// @_exported import class DVFDatabase.DVFDataManager

// Database protocols (to be implemented)
// @_exported import protocol DVFDatabase.DVFDataService
// @_exported import protocol DVFDatabase.DVFQueryService

// Database errors (to be implemented)
// @_exported import enum DVFDatabase.DVFDatabaseError

/// Placeholder for future database implementation
public struct DVFDatabasePlaceholder {
    public static let message = "Database module implementation coming soon"
}

/// Main entry point for the DVFDatabase module
public struct DVFDatabase: @unchecked Sendable {
    
    /// Shared database instance
    public static let shared = DVFDatabase()
    
    /// Firestore database instance
    public let firestore: Firestore
    
    /// Database configuration
    public var configuration: DatabaseConfiguration
    
    private init() {
        self.firestore = Firestore.firestore()
        self.configuration = DatabaseConfiguration()
    }
    
    /// Initialize database with custom configuration
    /// - Parameter config: Database configuration settings
    public init(configuration config: DatabaseConfiguration) {
        self.firestore = Firestore.firestore()
        self.configuration = config
    }
    
    /// Configure database settings
    /// - Parameter config: New configuration settings
    public mutating func configure(with config: DatabaseConfiguration) {
        self.configuration = config
    }
    
    /// Reset database to default settings
    public mutating func reset() {
        self.configuration = DatabaseConfiguration()
    }
}

/// Database configuration settings
public struct DatabaseConfiguration {
    /// Enable offline persistence
    public var enableOfflinePersistence: Bool = true
    
    /// Cache size in bytes
    public var cacheSizeBytes: Int64 = 100 * 1024 * 1024 // 100MB
    
    /// Enable network connectivity monitoring
    public var enableNetworkMonitoring: Bool = true
    
    /// Collection name for facilities
    public var facilitiesCollection: String = "facilities"
    
    /// Collection name for buildings
    public var buildingsCollection: String = "buildings"
    
    /// Collection name for users
    public var usersCollection: String = "users"
    
    public init() {}
}

/// Database service for CRUD operations
public class DVFDatabaseService {
    private let database: DVFDatabase
    
    public init(database: DVFDatabase = .shared) {
        self.database = database
    }
    
    /// Save a facility to the database
    /// - Parameter facility: Facility to save
    /// - Returns: Document ID of the saved facility
    public func saveFacility(_ facility: DVFFacility) async throws -> String {
        let docRef = database.firestore.collection(database.configuration.facilitiesCollection).document()
        try docRef.setData(from: facility)
        return docRef.documentID
    }
    
    /// Retrieve a facility by ID
    /// - Parameter id: Facility ID
    /// - Returns: Facility if found
    public func getFacility(id: String) async throws -> DVFFacility? {
        let docRef = database.firestore.collection(database.configuration.facilitiesCollection).document(id)
        let document = try await docRef.getDocument()
        return try document.data(as: DVFFacility.self)
    }
    
    /// Delete a facility by ID
    /// - Parameter id: Facility ID to delete
    public func deleteFacility(id: String) async throws {
        let docRef = database.firestore.collection(database.configuration.facilitiesCollection).document(id)
        try await docRef.delete()
    }
    
    /// Save a building to the database
    /// - Parameter building: Building to save
    /// - Returns: Document ID of the saved building
    public func saveBuilding(_ building: DVFBuilding) async throws -> String {
        let docRef = database.firestore.collection(database.configuration.buildingsCollection).document()
        try docRef.setData(from: building)
        return docRef.documentID
    }
    
    /// Retrieve a building by ID
    /// - Parameter id: Building ID
    /// - Returns: Building if found
    public func getBuilding(id: String) async throws -> DVFBuilding? {
        let docRef = database.firestore.collection(database.configuration.buildingsCollection).document(id)
        let document = try await docRef.getDocument()
        return try document.data(as: DVFBuilding.self)
    }
    
    /// Delete a building by ID
    /// - Parameter id: Building ID to delete
    public func deleteBuilding(id: String) async throws {
        let docRef = database.firestore.collection(database.configuration.buildingsCollection).document(id)
        try await docRef.delete()
    }
} 