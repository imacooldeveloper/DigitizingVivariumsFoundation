import Foundation

/// Protocol defining entities that track creation and modification timestamps.
///
/// This protocol ensures consistent timestamp tracking across all entities
/// in the vivarium digitization system, enabling audit trails and data
/// synchronization.
public protocol DVFTimestamped {
    
    /// When the entity was created
    var createdAt: Date { get }
    
    /// When the entity was last modified
    var updatedAt: Date { get }
    
    /// When the entity was last accessed (optional, for caching purposes)
    var lastAccessedAt: Date? { get set }
}

/// Extension providing default timestamp behavior
public extension DVFTimestamped {
    
    /// Update the last accessed timestamp to the current time
    mutating func updateLastAccessed() {
        lastAccessedAt = Date()
    }
    
    /// Check if the entity has been modified since a given date
    func hasBeenModified(since date: Date) -> Bool {
        return updatedAt > date
    }
    
    /// Check if the entity has been accessed since a given date
    func hasBeenAccessed(since date: Date) -> Bool {
        guard let lastAccessed = lastAccessedAt else { return false }
        return lastAccessed > date
    }
    
    /// Get the age of the entity in days
    var ageInDays: Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
    }
    
    /// Get the time since last modification in hours
    var hoursSinceLastModification: Double {
        return Date().timeIntervalSince(updatedAt) / 3600.0
    }
}

/// Protocol for entities that support soft deletion with deletion timestamps
public protocol DVFSoftDeletable: DVFTimestamped {
    
    /// When the entity was soft deleted (nil if not deleted)
    var deletedAt: Date? { get set }
    
    /// Whether the entity has been soft deleted
    var isDeleted: Bool { get }
}

/// Extension providing soft deletion behavior
public extension DVFSoftDeletable {
    
    /// Whether the entity has been soft deleted
    var isDeleted: Bool {
        return deletedAt != nil
    }
    
    /// Soft delete the entity by setting the deletion timestamp
    mutating func softDelete() {
        deletedAt = Date()
        updateLastAccessed()
    }
    
    /// Restore a soft-deleted entity by clearing the deletion timestamp
    mutating func restore() {
        deletedAt = nil
        updateLastAccessed()
    }
    
    /// Get the time since deletion in days
    var daysSinceDeletion: Int? {
        guard let deletedAt = deletedAt else { return nil }
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: deletedAt, to: Date()).day
    }
} 