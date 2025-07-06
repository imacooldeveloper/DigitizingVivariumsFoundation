import Foundation

/// Protocol defining entities that have a unique identifier.
///
/// This protocol provides a foundation for all identifiable entities
/// in the vivarium digitization system, ensuring consistent ID handling
/// across all data models.
public protocol DVFIdentifiable {
    
    /// Unique identifier for the entity
    var id: String { get }
    
    /// Type of the entity for categorization and validation
    var entityType: DVFEntityType { get }
}

/// Types of entities in the vivarium digitization system
public enum DVFEntityType: String, CaseIterable, Codable {
    case facility = "facility"
    case building = "building"
    case location = "location"
    case room = "room"
    case equipment = "equipment"
    case animal = "animal"
    case user = "user"
    case role = "role"
    case configuration = "configuration"
    case audit = "audit"
    
    /// Human-readable description of the entity type
    public var description: String {
        switch self {
        case .facility: return "Facility"
        case .building: return "Building"
        case .location: return "Location"
        case .room: return "Room"
        case .equipment: return "Equipment"
        case .animal: return "Animal"
        case .user: return "User"
        case .role: return "Role"
        case .configuration: return "Configuration"
        case .audit: return "Audit"
        }
    }
    
    /// Whether this entity type supports hierarchical relationships
    public var supportsHierarchy: Bool {
        switch self {
        case .facility, .building, .location, .room:
            return true
        case .equipment, .animal, .user, .role, .configuration, .audit:
            return false
        }
    }
    
    /// Whether this entity type requires facility scoping
    public var requiresFacilityScope: Bool {
        switch self {
        case .facility:
            return false
        case .building, .location, .room, .equipment, .animal, .user, .role, .configuration, .audit:
            return true
        }
    }
}

/// Extension providing default ID generation for identifiable entities
public extension DVFIdentifiable {
    
    /// Generate a new unique identifier for the entity type
    static func generateID(for entityType: DVFEntityType) -> String {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let random = Int.random(in: 1000...9999)
        return "\(entityType.rawValue)_\(timestamp)_\(random)"
    }
    
    /// Validate that an ID follows the expected format for the entity type
    static func isValidID(_ id: String, for entityType: DVFEntityType) -> Bool {
        let pattern = "^\(entityType.rawValue)_\\d+_\\d{4}$"
        return id.range(of: pattern, options: .regularExpression) != nil
    }
} 