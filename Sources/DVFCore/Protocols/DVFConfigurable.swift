import Foundation

/// Protocol defining entities that can be configured.
///
/// This protocol provides a foundation for configuration management
/// across the vivarium digitization system, enabling flexible
/// customization of behavior and appearance.
public protocol DVFConfigurable {
    
    /// The configuration object for this entity
    associatedtype ConfigurationType: DVFConfiguration
    
    /// Current configuration
    var configuration: ConfigurationType { get }
    
    /// Update the configuration
    /// - Parameter newConfiguration: The new configuration to apply
    /// - Throws: DVFConfigurationError if the configuration is invalid
    mutating func updateConfiguration(_ newConfiguration: ConfigurationType) throws
    
    /// Reset the configuration to default values
    mutating func resetConfiguration()
}

/// Base protocol for all configuration objects
public protocol DVFConfiguration: Codable, DVFValidatable {
    
    /// The type of configuration
    var configurationType: DVFConfigurationType { get }
    
    /// Version of the configuration schema
    var version: String { get }
    
    /// Whether this configuration is the default
    var isDefault: Bool { get }
}

/// Types of configurations in the system
public enum DVFConfigurationType: String, CaseIterable, Codable {
    case facility = "facility"
    case user = "user"
    case equipment = "equipment"
    case animal = "animal"
    case ui = "ui"
    case database = "database"
    case authentication = "authentication"
    case reporting = "reporting"
    case notification = "notification"
    case security = "security"
    
    /// Human-readable description of the configuration type
    public var description: String {
        switch self {
        case .facility: return "Facility Configuration"
        case .user: return "User Configuration"
        case .equipment: return "Equipment Configuration"
        case .animal: return "Animal Configuration"
        case .ui: return "UI Configuration"
        case .database: return "Database Configuration"
        case .authentication: return "Authentication Configuration"
        case .reporting: return "Reporting Configuration"
        case .notification: return "Notification Configuration"
        case .security: return "Security Configuration"
        }
    }
}

/// Configuration errors that can occur
public enum DVFConfigurationError: LocalizedError {
    case invalidConfiguration(String)
    case unsupportedVersion(String)
    case migrationRequired(String, String)
    case validationFailed([DVFValidationError])
    case serializationFailed(String)
    case deserializationFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidConfiguration(let reason):
            return "Invalid configuration: \(reason)"
        case .unsupportedVersion(let version):
            return "Unsupported configuration version: \(version)"
        case .migrationRequired(let fromVersion, let toVersion):
            return "Configuration migration required from \(fromVersion) to \(toVersion)"
        case .validationFailed(let errors):
            return "Configuration validation failed: \(errors.map { $0.localizedDescription }.joined(separator: "; "))"
        case .serializationFailed(let reason):
            return "Configuration serialization failed: \(reason)"
        case .deserializationFailed(let reason):
            return "Configuration deserialization failed: \(reason)"
        }
    }
}

/// Extension providing default configuration behavior
public extension DVFConfigurable {
    
    /// Update the configuration with validation
    /// - Parameter newConfiguration: The new configuration to apply
    /// - Throws: DVFConfigurationError if the configuration is invalid
    mutating func updateConfiguration(_ newConfiguration: ConfigurationType) throws {
        // Validate the new configuration
        let errors = newConfiguration.validate()
        if !errors.isEmpty {
            throw DVFConfigurationError.validationFailed(errors)
        }
        
        // Apply the configuration
        try applyConfiguration(newConfiguration)
    }
    
    /// Apply the configuration (to be implemented by concrete types)
    /// - Parameter configuration: The configuration to apply
    /// - Throws: DVFConfigurationError if application fails
    func applyConfiguration(_ configuration: ConfigurationType) throws {
        // Default implementation does nothing
        // Concrete types should override this method
    }
}

/// Protocol for configurations that support migration between versions
public protocol DVFVersionedConfiguration: DVFConfiguration {
    
    /// Migrate this configuration to a newer version
    /// - Parameter targetVersion: The target version to migrate to
    /// - Returns: The migrated configuration
    /// - Throws: DVFConfigurationError if migration fails
    func migrate(to targetVersion: String) throws -> Self
}

/// Protocol for configurations that can be merged
public protocol DVFMergeableConfiguration: DVFConfiguration {
    
    /// Merge this configuration with another configuration
    /// - Parameter other: The configuration to merge with
    /// - Returns: The merged configuration
    /// - Throws: DVFConfigurationError if merge fails
    func merge(with other: Self) throws -> Self
}

