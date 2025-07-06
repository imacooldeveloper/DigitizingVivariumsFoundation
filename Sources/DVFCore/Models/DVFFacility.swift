import Foundation

/// A facility represents the top-level organizational unit in the vivarium digitization system.
///
/// Facilities are the root entities that contain all other organizational units
/// such as buildings, locations, and rooms. Each facility operates independently
/// with its own configuration, users, and data.
public struct DVFFacility: DVFIdentifiable, DVFTimestamped, DVFValidatable, DVFConfigurable, Codable {
    
    // MARK: - Core Properties
    
    /// Unique identifier for the facility
    public let id: String
    
    /// Type of entity (always .facility)
    public let entityType: DVFEntityType = .facility
    
    /// Name of the facility
    public let name: String
    
    /// Description of the facility
    public let description: String?
    
    /// Facility type (e.g., research, breeding, quarantine)
    public let facilityType: DVFFacilityType
    
    /// Status of the facility
    public let status: DVFFacilityStatus
    
    /// Contact information for the facility
    public let contactInfo: DVFContactInfo
    
    /// Address of the facility
    public let address: DVFAddress
    
    /// Operating hours for the facility
    public let operatingHours: DVFOperatingHours
    
    /// Current configuration for the facility
    public let configuration: DVFFacilityConfiguration
    
    // MARK: - Timestamps
    
    /// When the facility was created
    public let createdAt: Date
    
    /// When the facility was last modified
    public let updatedAt: Date
    
    /// When the facility was last accessed
    public var lastAccessedAt: Date?
    
    // MARK: - Initialization
    
    /// Initialize a new facility
    /// - Parameters:
    ///   - id: Unique identifier (auto-generated if nil)
    ///   - name: Name of the facility
    ///   - description: Optional description
    ///   - facilityType: Type of facility
    ///   - status: Current status
    ///   - contactInfo: Contact information
    ///   - address: Physical address
    ///   - operatingHours: Operating hours
    ///   - configuration: Facility configuration
    public init(
        id: String? = nil,
        name: String,
        description: String? = nil,
        facilityType: DVFFacilityType,
        status: DVFFacilityStatus = .active,
        contactInfo: DVFContactInfo,
        address: DVFAddress,
        operatingHours: DVFOperatingHours,
        configuration: DVFFacilityConfiguration = DVFFacilityConfiguration.default
    ) {
        self.id = id ?? Self.generateID(for: .facility)
        self.name = name
        self.description = description
        self.facilityType = facilityType
        self.status = status
        self.contactInfo = contactInfo
        self.address = address
        self.operatingHours = operatingHours
        self.configuration = configuration
        self.createdAt = Date()
        self.updatedAt = Date()
        self.lastAccessedAt = nil
    }
    
    // MARK: - DVFValidatable
    
    public func validate() -> [DVFValidationError] {
        var errors: [DVFValidationError] = []
        
        // Validate required fields
        if let error = Self.validateRequiredString(name, fieldName: "name") {
            errors.append(error)
        }
        
        if let error = Self.validateRequiredString(contactInfo.email, fieldName: "contactInfo.email") {
            errors.append(error)
        }
        
        // Validate email format
        if let error = Self.validateStringPattern(contactInfo.email, pattern: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", fieldName: "contactInfo.email") {
            errors.append(error)
        }
        
        // Validate phone format
        if let phone = contactInfo.phone, !phone.isEmpty {
            if let error = Self.validateStringPattern(phone, pattern: "^[+]?[0-9\\s\\-\\(\\)]{10,}$", fieldName: "contactInfo.phone") {
                errors.append(error)
            }
        }
        
        // Validate configuration
        errors.append(contentsOf: configuration.validate())
        
        return errors
    }
    
    // MARK: - DVFConfigurable
    
    public mutating func updateConfiguration(_ newConfiguration: DVFFacilityConfiguration) throws {
        // This would need to be implemented with proper mutability
        // For now, we'll throw an error indicating this needs to be implemented
        throw DVFConfigurationError.invalidConfiguration("Configuration updates not yet implemented")
    }
    
    public mutating func resetConfiguration() {
        // This would need to be implemented with proper mutability
    }
    
    // MARK: - Convenience Methods
    
    /// Check if the facility is currently open
    public var isCurrentlyOpen: Bool {
        return operatingHours.isCurrentlyOpen
    }
    
    /// Get the facility's full address as a formatted string
    public var formattedAddress: String {
        return address.formattedAddress
    }
    
    /// Get the facility's contact information as a formatted string
    public var formattedContactInfo: String {
        return contactInfo.formattedContactInfo
    }
}

/// Types of facilities in the system
public enum DVFFacilityType: String, CaseIterable, Codable {
    case research = "research"
    case breeding = "breeding"
    case quarantine = "quarantine"
    case storage = "storage"
    case mixed = "mixed"
    case other = "other"
    
    /// Human-readable description of the facility type
    public var description: String {
        switch self {
        case .research: return "Research Facility"
        case .breeding: return "Breeding Facility"
        case .quarantine: return "Quarantine Facility"
        case .storage: return "Storage Facility"
        case .mixed: return "Mixed Purpose Facility"
        case .other: return "Other"
        }
    }
}

/// Status of a facility
public enum DVFFacilityStatus: String, CaseIterable, Codable, Sendable {
    case active = "active"
    case inactive = "inactive"
    case maintenance = "maintenance"
    case emergency = "emergency"
    case decommissioned = "decommissioned"
    
    /// Human-readable description of the facility status
    public var description: String {
        switch self {
        case .active: return "Active"
        case .inactive: return "Inactive"
        case .maintenance: return "Under Maintenance"
        case .emergency: return "Emergency Mode"
        case .decommissioned: return "Decommissioned"
        }
    }
    
    /// Whether the facility is operational
    public var isOperational: Bool {
        switch self {
        case .active, .maintenance:
            return true
        case .inactive, .emergency, .decommissioned:
            return false
        }
    }
}

/// Contact information for a facility
public struct DVFContactInfo: Codable, DVFValidatable {
    public let email: String
    public let phone: String?
    public let fax: String?
    public let website: String?
    public let emergencyContact: String?
    
    public init(
        email: String,
        phone: String? = nil,
        fax: String? = nil,
        website: String? = nil,
        emergencyContact: String? = nil
    ) {
        self.email = email
        self.phone = phone
        self.fax = fax
        self.website = website
        self.emergencyContact = emergencyContact
    }
    
    public func validate() -> [DVFValidationError] {
        var errors: [DVFValidationError] = []
        
        if let error = Self.validateRequiredString(email, fieldName: "email") {
            errors.append(error)
        }
        
        if let error = Self.validateStringPattern(email, pattern: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", fieldName: "email") {
            errors.append(error)
        }
        
        return errors
    }
    
    public var formattedContactInfo: String {
        var parts: [String] = []
        parts.append("Email: \(email)")
        
        if let phone = phone {
            parts.append("Phone: \(phone)")
        }
        
        if let fax = fax {
            parts.append("Fax: \(fax)")
        }
        
        if let website = website {
            parts.append("Website: \(website)")
        }
        
        if let emergencyContact = emergencyContact {
            parts.append("Emergency: \(emergencyContact)")
        }
        
        return parts.joined(separator: "\n")
    }
}

/// Physical address for a facility
public struct DVFAddress: Codable, DVFValidatable {
    public let street: String
    public let city: String
    public let state: String
    public let zipCode: String
    public let country: String
    public let buildingNumber: String?
    public let suite: String?
    
    public init(
        street: String,
        city: String,
        state: String,
        zipCode: String,
        country: String,
        buildingNumber: String? = nil,
        suite: String? = nil
    ) {
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
        self.buildingNumber = buildingNumber
        self.suite = suite
    }
    
    public func validate() -> [DVFValidationError] {
        var errors: [DVFValidationError] = []
        
        if let error = Self.validateRequiredString(street, fieldName: "street") {
            errors.append(error)
        }
        
        if let error = Self.validateRequiredString(city, fieldName: "city") {
            errors.append(error)
        }
        
        if let error = Self.validateRequiredString(state, fieldName: "state") {
            errors.append(error)
        }
        
        if let error = Self.validateRequiredString(zipCode, fieldName: "zipCode") {
            errors.append(error)
        }
        
        if let error = Self.validateRequiredString(country, fieldName: "country") {
            errors.append(error)
        }
        
        return errors
    }
    
    public var formattedAddress: String {
        var parts: [String] = []
        
        if let buildingNumber = buildingNumber {
            parts.append(buildingNumber)
        }
        
        parts.append(street)
        
        if let suite = suite {
            parts.append("Suite \(suite)")
        }
        
        parts.append("\(city), \(state) \(zipCode)")
        parts.append(country)
        
        return parts.joined(separator: "\n")
    }
}

/// Operating hours for a facility
public struct DVFOperatingHours: Codable, DVFValidatable {
    public let monday: DVFDayHours
    public let tuesday: DVFDayHours
    public let wednesday: DVFDayHours
    public let thursday: DVFDayHours
    public let friday: DVFDayHours
    public let saturday: DVFDayHours
    public let sunday: DVFDayHours
    
    public init(
        monday: DVFDayHours,
        tuesday: DVFDayHours,
        wednesday: DVFDayHours,
        thursday: DVFDayHours,
        friday: DVFDayHours,
        saturday: DVFDayHours,
        sunday: DVFDayHours
    ) {
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
        self.sunday = sunday
    }
    
    public func validate() -> [DVFValidationError] {
        var errors: [DVFValidationError] = []
        
        errors.append(contentsOf: monday.validate())
        errors.append(contentsOf: tuesday.validate())
        errors.append(contentsOf: wednesday.validate())
        errors.append(contentsOf: thursday.validate())
        errors.append(contentsOf: friday.validate())
        errors.append(contentsOf: saturday.validate())
        errors.append(contentsOf: sunday.validate())
        
        return errors
    }
    
    public var isCurrentlyOpen: Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        
        let dayHours: DVFDayHours
        switch weekday {
        case 1: dayHours = sunday
        case 2: dayHours = monday
        case 3: dayHours = tuesday
        case 4: dayHours = wednesday
        case 5: dayHours = thursday
        case 6: dayHours = friday
        case 7: dayHours = saturday
        default: return false
        }
        
        return dayHours.isCurrentlyOpen
    }
}

/// Operating hours for a specific day
public struct DVFDayHours: Codable, DVFValidatable {
    public let isOpen: Bool
    public let openTime: Date?
    public let closeTime: Date?
    
    public init(isOpen: Bool, openTime: Date? = nil, closeTime: Date? = nil) {
        self.isOpen = isOpen
        self.openTime = openTime
        self.closeTime = closeTime
    }
    
    public func validate() -> [DVFValidationError] {
        var errors: [DVFValidationError] = []
        
        if isOpen {
            if openTime == nil {
                errors.append(.requiredFieldMissing("openTime"))
            }
            
            if closeTime == nil {
                errors.append(.requiredFieldMissing("closeTime"))
            }
            
            if let openTime = openTime, let closeTime = closeTime {
                if openTime >= closeTime {
                    errors.append(.businessRuleViolation("Open time must be before close time"))
                }
            }
        }
        
        return errors
    }
    
    public var isCurrentlyOpen: Bool {
        guard isOpen, let openTime = openTime, let closeTime = closeTime else {
            return false
        }
        
        let now = Date()
        let calendar = Calendar.current
        
        let openComponents = calendar.dateComponents([.hour, .minute], from: openTime)
        let closeComponents = calendar.dateComponents([.hour, .minute], from: closeTime)
        let nowComponents = calendar.dateComponents([.hour, .minute], from: now)
        
        let openMinutes = (openComponents.hour ?? 0) * 60 + (openComponents.minute ?? 0)
        let closeMinutes = (closeComponents.hour ?? 0) * 60 + (closeComponents.minute ?? 0)
        let nowMinutes = (nowComponents.hour ?? 0) * 60 + (nowComponents.minute ?? 0)
        
        return nowMinutes >= openMinutes && nowMinutes <= closeMinutes
    }
} 