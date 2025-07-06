import Foundation

/// Core errors that can occur in the DVFCore module.
///
/// This enum defines all the error types that can be thrown by
/// core functionality in the vivarium digitization system.
public enum DVFCoreError: LocalizedError {
    
    // MARK: - Initialization Errors
    
    /// Failed to initialize a core component
    case initializationFailed(String)
    
    /// Configuration is missing or invalid
    case configurationError(String)
    
    /// Required dependency is missing
    case missingDependency(String)
    
    // MARK: - Data Model Errors
    
    /// Entity validation failed
    case validationFailed([DVFValidationError])
    
    /// Entity not found
    case entityNotFound(String, String) // entityType, id
    
    /// Entity already exists
    case entityAlreadyExists(String, String) // entityType, id
    
    /// Invalid entity relationship
    case invalidRelationship(String, String) // entityType, reason
    
    // MARK: - Configuration Errors
    
    /// Configuration not found
    case configurationNotFound(String)
    
    /// Configuration is invalid
    case invalidConfiguration(String)
    
    /// Configuration migration failed
    case configurationMigrationFailed(String, String) // fromVersion, toVersion
    
    // MARK: - Facility Errors
    
    /// Facility not found
    case facilityNotFound(String)
    
    /// Facility access denied
    case facilityAccessDenied(String, String) // facilityID, reason
    
    /// Facility is not operational
    case facilityNotOperational(String, DVFFacilityStatus)
    
    /// Facility capacity exceeded
    case facilityCapacityExceeded(String, String) // facilityID, capacityType
    
    // MARK: - Hierarchy Errors
    
    /// Invalid hierarchy operation
    case invalidHierarchyOperation(String)
    
    /// Circular reference detected
    case circularReference(String, String) // entityType, id
    
    /// Parent not found
    case parentNotFound(String, String) // entityType, parentID
    
    /// Child not found
    case childNotFound(String, String) // entityType, childID
    
    // MARK: - Transfer Errors
    
    /// Transfer operation failed
    case transferFailed(String, String) // fromEntity, toEntity
    
    /// Transfer not allowed
    case transferNotAllowed(String, String) // entityType, reason
    
    /// Transfer validation failed
    case transferValidationFailed(String, [DVFValidationError])
    
    // MARK: - System Errors
    
    /// System is not ready
    case systemNotReady(String)
    
    /// System is in maintenance mode
    case systemMaintenance(String)
    
    /// System error occurred
    case systemError(String)
    
    /// Network error occurred
    case networkError(String)
    
    /// Database error occurred
    case databaseError(String)
    
    // MARK: - Permission Errors
    
    /// Permission denied
    case permissionDenied(String, String) // action, reason
    
    /// Insufficient privileges
    case insufficientPrivileges(String, String) // required, current
    
    /// Authentication required
    case authenticationRequired(String)
    
    // MARK: - Resource Errors
    
    /// Resource not found
    case resourceNotFound(String)
    
    /// Resource is locked
    case resourceLocked(String, String) // resource, reason
    
    /// Resource is in use
    case resourceInUse(String, String) // resource, user
    
    /// Resource limit exceeded
    case resourceLimitExceeded(String, String) // resource, limit
    
    // MARK: - Custom Errors
    
    /// Custom error with message
    case custom(String)
    
    // MARK: - LocalizedError
    
    public var errorDescription: String? {
        switch self {
        case .initializationFailed(let reason):
            return "Initialization failed: \(reason)"
        case .configurationError(let reason):
            return "Configuration error: \(reason)"
        case .missingDependency(let dependency):
            return "Missing dependency: \(dependency)"
        case .validationFailed(let errors):
            return "Validation failed: \(errors.map { $0.localizedDescription }.joined(separator: "; "))"
        case .entityNotFound(let entityType, let id):
            return "\(entityType) not found: \(id)"
        case .entityAlreadyExists(let entityType, let id):
            return "\(entityType) already exists: \(id)"
        case .invalidRelationship(let entityType, let reason):
            return "Invalid \(entityType) relationship: \(reason)"
        case .configurationNotFound(let key):
            return "Configuration not found: \(key)"
        case .invalidConfiguration(let reason):
            return "Invalid configuration: \(reason)"
        case .configurationMigrationFailed(let fromVersion, let toVersion):
            return "Configuration migration failed from \(fromVersion) to \(toVersion)"
        case .facilityNotFound(let facilityID):
            return "Facility not found: \(facilityID)"
        case .facilityAccessDenied(let facilityID, let reason):
            return "Access denied to facility \(facilityID): \(reason)"
        case .facilityNotOperational(let facilityID, let status):
            return "Facility \(facilityID) is not operational (status: \(status.description))"
        case .facilityCapacityExceeded(let facilityID, let capacityType):
            return "Facility \(facilityID) capacity exceeded for \(capacityType)"
        case .invalidHierarchyOperation(let reason):
            return "Invalid hierarchy operation: \(reason)"
        case .circularReference(let entityType, let id):
            return "Circular reference detected in \(entityType): \(id)"
        case .parentNotFound(let entityType, let parentID):
            return "Parent not found for \(entityType): \(parentID)"
        case .childNotFound(let entityType, let childID):
            return "Child not found for \(entityType): \(childID)"
        case .transferFailed(let fromEntity, let toEntity):
            return "Transfer failed from \(fromEntity) to \(toEntity)"
        case .transferNotAllowed(let entityType, let reason):
            return "Transfer not allowed for \(entityType): \(reason)"
        case .transferValidationFailed(let entityType, let errors):
            return "Transfer validation failed for \(entityType): \(errors.map { $0.localizedDescription }.joined(separator: "; "))"
        case .systemNotReady(let reason):
            return "System not ready: \(reason)"
        case .systemMaintenance(let reason):
            return "System maintenance: \(reason)"
        case .systemError(let reason):
            return "System error: \(reason)"
        case .networkError(let reason):
            return "Network error: \(reason)"
        case .databaseError(let reason):
            return "Database error: \(reason)"
        case .permissionDenied(let action, let reason):
            return "Permission denied for \(action): \(reason)"
        case .insufficientPrivileges(let required, let current):
            return "Insufficient privileges. Required: \(required), Current: \(current)"
        case .authenticationRequired(let reason):
            return "Authentication required: \(reason)"
        case .resourceNotFound(let resource):
            return "Resource not found: \(resource)"
        case .resourceLocked(let resource, let reason):
            return "Resource \(resource) is locked: \(reason)"
        case .resourceInUse(let resource, let user):
            return "Resource \(resource) is in use by \(user)"
        case .resourceLimitExceeded(let resource, let limit):
            return "Resource limit exceeded for \(resource): \(limit)"
        case .custom(let message):
            return message
        }
    }
    
    /// Recovery suggestion for the error
    public var failureReason: String? {
        switch self {
        case .initializationFailed:
            return "Check that all required components are properly configured"
        case .configurationError:
            return "Verify configuration settings and try again"
        case .missingDependency:
            return "Ensure all required dependencies are installed and configured"
        case .validationFailed:
            return "Correct the validation errors and try again"
        case .entityNotFound:
            return "Verify the entity exists and you have access to it"
        case .entityAlreadyExists:
            return "Use a different identifier or update the existing entity"
        case .invalidRelationship:
            return "Check the relationship configuration and try again"
        case .configurationNotFound:
            return "Create or restore the missing configuration"
        case .invalidConfiguration:
            return "Review and correct the configuration settings"
        case .configurationMigrationFailed:
            return "Contact support for configuration migration assistance"
        case .facilityNotFound:
            return "Verify the facility ID and your access permissions"
        case .facilityAccessDenied:
            return "Contact your administrator for access permissions"
        case .facilityNotOperational:
            return "Wait for the facility to become operational or contact support"
        case .facilityCapacityExceeded:
            return "Reduce usage or contact administrator to increase capacity"
        case .invalidHierarchyOperation:
            return "Check the hierarchy structure and try again"
        case .circularReference:
            return "Review the entity relationships to remove circular references"
        case .parentNotFound, .childNotFound:
            return "Verify the parent/child relationship exists"
        case .transferFailed, .transferNotAllowed, .transferValidationFailed:
            return "Check transfer requirements and permissions"
        case .systemNotReady:
            return "Wait for the system to initialize completely"
        case .systemMaintenance:
            return "Wait for maintenance to complete"
        case .systemError, .networkError, .databaseError:
            return "Try again later or contact support if the problem persists"
        case .permissionDenied, .insufficientPrivileges:
            return "Contact your administrator for appropriate permissions"
        case .authenticationRequired:
            return "Sign in with valid credentials"
        case .resourceNotFound:
            return "Verify the resource exists and is accessible"
        case .resourceLocked, .resourceInUse:
            return "Wait for the resource to become available"
        case .resourceLimitExceeded:
            return "Reduce resource usage or contact administrator"
        case .custom:
            return "Review the error details and try again"
        }
    }
    
    /// Whether the error is recoverable
    public var isRecoverable: Bool {
        switch self {
        case .initializationFailed, .configurationError, .missingDependency,
             .validationFailed, .invalidConfiguration, .configurationMigrationFailed,
             .invalidRelationship, .invalidHierarchyOperation, .circularReference,
             .transferValidationFailed, .systemError, .networkError, .databaseError:
            return true
        case .entityNotFound, .entityAlreadyExists, .configurationNotFound,
             .facilityNotFound, .parentNotFound, .childNotFound, .resourceNotFound:
            return false
        case .facilityAccessDenied, .facilityNotOperational, .facilityCapacityExceeded,
             .transferFailed, .transferNotAllowed, .systemNotReady, .systemMaintenance,
             .permissionDenied, .insufficientPrivileges, .authenticationRequired,
             .resourceLocked, .resourceInUse, .resourceLimitExceeded:
            return true
        case .custom:
            return true
        }
    }
    
    /// Suggested recovery action
    public var recoveryAction: String? {
        switch self {
        case .initializationFailed:
            return "Restart the application"
        case .configurationError:
            return "Check configuration files"
        case .missingDependency:
            return "Install missing dependencies"
        case .validationFailed:
            return "Fix validation errors"
        case .entityNotFound:
            return "Check entity ID"
        case .entityAlreadyExists:
            return "Use different ID"
        case .invalidRelationship:
            return "Fix relationship configuration"
        case .configurationNotFound:
            return "Create configuration"
        case .invalidConfiguration:
            return "Update configuration"
        case .configurationMigrationFailed:
            return "Contact support"
        case .facilityNotFound:
            return "Check facility ID"
        case .facilityAccessDenied:
            return "Request access"
        case .facilityNotOperational:
            return "Wait for facility"
        case .facilityCapacityExceeded:
            return "Reduce usage"
        case .invalidHierarchyOperation:
            return "Fix hierarchy"
        case .circularReference:
            return "Remove circular reference"
        case .parentNotFound, .childNotFound:
            return "Check relationships"
        case .transferFailed, .transferNotAllowed, .transferValidationFailed:
            return "Check transfer requirements"
        case .systemNotReady:
            return "Wait for system"
        case .systemMaintenance:
            return "Wait for maintenance"
        case .systemError, .networkError, .databaseError:
            return "Retry later"
        case .permissionDenied, .insufficientPrivileges:
            return "Request permissions"
        case .authenticationRequired:
            return "Sign in"
        case .resourceNotFound:
            return "Check resource"
        case .resourceLocked, .resourceInUse:
            return "Wait for resource"
        case .resourceLimitExceeded:
            return "Reduce usage"
        case .custom:
            return "Review error"
        }
    }
} 