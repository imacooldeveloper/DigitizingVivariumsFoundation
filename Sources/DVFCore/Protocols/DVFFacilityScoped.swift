import Foundation

/// Protocol defining entities that are scoped to a specific facility.
///
/// This protocol ensures proper multi-tenant isolation by requiring
/// all facility-scoped entities to be associated with a specific facility.
public protocol DVFFacilityScoped {
    
    /// The ID of the facility this entity belongs to
    var facilityID: String { get }
    
    /// The facility this entity belongs to (computed property)
    var facility: DVFFacility? { get }
}

/// Protocol for entities that can be moved between facilities
public protocol DVFTransferable: DVFFacilityScoped {
    
    /// Transfer the entity to a different facility
    /// - Parameter newFacilityID: The ID of the target facility
    /// - Throws: DVFTransferError if the transfer is not allowed
    mutating func transfer(to newFacilityID: String) throws
}

/// Errors that can occur during facility transfers
public enum DVFTransferError: LocalizedError {
    case invalidFacilityID(String)
    case facilityNotFound(String)
    case transferNotAllowed(String)
    case validationFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidFacilityID(let id):
            return "Invalid facility ID: \(id)"
        case .facilityNotFound(let id):
            return "Facility not found: \(id)"
        case .transferNotAllowed(let reason):
            return "Transfer not allowed: \(reason)"
        case .validationFailed(let reason):
            return "Validation failed: \(reason)"
        }
    }
}

/// Extension providing facility scoping behavior
public extension DVFFacilityScoped {
    
    /// Check if the entity belongs to the specified facility
    /// - Parameter facilityID: The facility ID to check against
    /// - Returns: True if the entity belongs to the specified facility
    func belongsTo(facilityID: String) -> Bool {
        return self.facilityID == facilityID
    }
    
    /// Check if the entity belongs to any of the specified facilities
    /// - Parameter facilityIDs: Array of facility IDs to check against
    /// - Returns: True if the entity belongs to any of the specified facilities
    func belongsToAny(facilityIDs: [String]) -> Bool {
        return facilityIDs.contains(facilityID)
    }
}

/// Protocol for entities that support hierarchical facility relationships
public protocol DVFHierarchical: DVFFacilityScoped {
    
    /// The ID of the parent entity in the hierarchy
    var parentID: String? { get }
    
    /// The level of this entity in the hierarchy (0 = root)
    var hierarchyLevel: Int { get }
    
    /// The path from root to this entity in the hierarchy
    var hierarchyPath: [String] { get }
}

/// Extension providing hierarchical behavior
public extension DVFHierarchical {
    
    /// Check if this entity is a root entity (no parent)
    var isRoot: Bool {
        return parentID == nil
    }
    
    /// Check if this entity is a leaf entity (no children)
    var isLeaf: Bool {
        // This would need to be implemented by concrete types
        // that can determine if they have children
        return false
    }
    
    /// Get the depth of this entity in the hierarchy
    var depth: Int {
        return hierarchyPath.count - 1
    }
    
    /// Check if this entity is a descendant of the specified entity
    /// - Parameter entityID: The ID of the potential ancestor
    /// - Returns: True if this entity is a descendant
    func isDescendant(of entityID: String) -> Bool {
        return hierarchyPath.contains(entityID)
    }
    
    /// Check if this entity is an ancestor of the specified entity
    /// - Parameter entityID: The ID of the potential descendant
    /// - Returns: True if this entity is an ancestor
    func isAncestor(of entityID: String) -> Bool {
        // This would need to be implemented by concrete types
        // that can traverse the hierarchy
        return false
    }
} 