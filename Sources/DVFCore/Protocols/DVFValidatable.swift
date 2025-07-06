import Foundation

/// Protocol defining entities that can be validated.
///
/// This protocol ensures data integrity by providing validation
/// capabilities for all entities in the vivarium digitization system.
public protocol DVFValidatable {
    
    /// Validate the entity and return any validation errors
    /// - Returns: Array of validation errors, empty if valid
    func validate() -> [DVFValidationError]
    
    /// Check if the entity is valid
    var isValid: Bool { get }
}

/// Validation errors that can occur during entity validation
public enum DVFValidationError: LocalizedError, Equatable {
    case requiredFieldMissing(String)
    case invalidFormat(String, String)
    case valueOutOfRange(String, String, String)
    case duplicateValue(String, String)
    case invalidRelationship(String, String)
    case businessRuleViolation(String)
    case custom(String)
    
    public var errorDescription: String? {
        switch self {
        case .requiredFieldMissing(let field):
            return "Required field '\(field)' is missing"
        case .invalidFormat(let field, let expectedFormat):
            return "Field '\(field)' has invalid format. Expected: \(expectedFormat)"
        case .valueOutOfRange(let field, let value, let range):
            return "Field '\(field)' value '\(value)' is out of range. Valid range: \(range)"
        case .duplicateValue(let field, let value):
            return "Field '\(field)' value '\(value)' already exists"
        case .invalidRelationship(let field, let reason):
            return "Field '\(field)' has invalid relationship: \(reason)"
        case .businessRuleViolation(let rule):
            return "Business rule violation: \(rule)"
        case .custom(let message):
            return message
        }
    }
    
    /// The field name associated with this validation error
    public var fieldName: String? {
        switch self {
        case .requiredFieldMissing(let field),
             .invalidFormat(let field, _),
             .valueOutOfRange(let field, _, _),
             .duplicateValue(let field, _),
             .invalidRelationship(let field, _):
            return field
        case .businessRuleViolation, .custom:
            return nil
        }
    }
}

/// Extension providing default validation behavior
public extension DVFValidatable {
    
    /// Check if the entity is valid
    var isValid: Bool {
        return validate().isEmpty
    }
    
    /// Validate the entity and throw an error if invalid
    /// - Throws: DVFValidationError if validation fails
    func validateAndThrow() throws {
        let errors = validate()
        if !errors.isEmpty {
            throw DVFValidationError.custom("Validation failed: \(errors.map { $0.localizedDescription }.joined(separator: "; "))")
        }
    }
}

/// Protocol for entities that support custom validation rules
public protocol DVFCustomValidatable: DVFValidatable {
    
    /// Custom validation rules specific to this entity type
    var customValidationRules: [DVFValidationRule] { get }
}

/// A validation rule that can be applied to entities
public struct DVFValidationRule {
    public let name: String
    public let validate: (DVFValidatable) -> [DVFValidationError]
    
    public init(name: String, validate: @escaping (DVFValidatable) -> [DVFValidationError]) {
        self.name = name
        self.validate = validate
    }
}

/// Extension providing common validation utilities
public extension DVFValidatable {
    
    /// Validate that a required string field is not empty
    /// - Parameters:
    ///   - value: The string value to validate
    ///   - fieldName: The name of the field for error reporting
    /// - Returns: Validation error if the field is empty or nil
    static func validateRequiredString(_ value: String?, fieldName: String) -> DVFValidationError? {
        guard let value = value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .requiredFieldMissing(fieldName)
        }
        return nil
    }
    
    /// Validate that a string matches a regular expression pattern
    /// - Parameters:
    ///   - value: The string value to validate
    ///   - pattern: The regular expression pattern
    ///   - fieldName: The name of the field for error reporting
    /// - Returns: Validation error if the pattern doesn't match
    static func validateStringPattern(_ value: String?, pattern: String, fieldName: String) -> DVFValidationError? {
        guard let value = value else { return nil }
        guard value.range(of: pattern, options: .regularExpression) != nil else {
            return .invalidFormat(fieldName, "Must match pattern: \(pattern)")
        }
        return nil
    }
    
    /// Validate that a numeric value is within a specified range
    /// - Parameters:
    ///   - value: The numeric value to validate
    ///   - min: The minimum allowed value
    ///   - max: The maximum allowed value
    ///   - fieldName: The name of the field for error reporting
    /// - Returns: Validation error if the value is out of range
    static func validateNumericRange<T: Comparable>(_ value: T?, min: T, max: T, fieldName: String) -> DVFValidationError? {
        guard let value = value else { return nil }
        guard value >= min && value <= max else {
            return .valueOutOfRange(fieldName, "\(value)", "\(min) to \(max)")
        }
        return nil
    }
    
    /// Validate that a date is within a specified range
    /// - Parameters:
    ///   - date: The date to validate
    ///   - earliest: The earliest allowed date
    ///   - latest: The latest allowed date
    ///   - fieldName: The name of the field for error reporting
    /// - Returns: Validation error if the date is out of range
    static func validateDateRange(_ date: Date?, earliest: Date, latest: Date, fieldName: String) -> DVFValidationError? {
        guard let date = date else { return nil }
        guard date >= earliest && date <= latest else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return .valueOutOfRange(fieldName, formatter.string(from: date), "\(formatter.string(from: earliest)) to \(formatter.string(from: latest))")
        }
        return nil
    }
} 