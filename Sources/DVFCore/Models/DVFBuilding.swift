import Foundation

/// A building represents a physical structure within a facility.
///
/// Buildings contain locations and rooms, and are part of the hierarchical
/// structure of a vivarium facility.
public struct DVFBuilding: DVFIdentifiable, DVFTimestamped, DVFValidatable, DVFFacilityScoped, DVFHierarchical, Codable {
    
    // MARK: - Core Properties
    
    /// Unique identifier for the building
    public let id: String
    
    /// Type of entity (always .building)
    public let entityType: DVFEntityType = .building
    
    /// Name of the building
    public let name: String
    
    /// Description of the building
    public let description: String?
    
    /// Building type (e.g., laboratory, office, storage)
    public let buildingType: DVFBuildingType
    
    /// Status of the building
    public let status: DVFBuildingStatus
    
    /// The facility this building belongs to
    public let facilityID: String
    
    /// The facility this building belongs to (computed property)
    public var facility: DVFFacility? {
        // This would be populated by the facility manager
        return nil
    }
    
    /// The parent entity in the hierarchy (facility)
    public let parentID: String?
    
    /// The level of this entity in the hierarchy (1 = building level)
    public let hierarchyLevel: Int = 1
    
    /// The path from root to this entity in the hierarchy
    public var hierarchyPath: [String] {
        return [facilityID, id]
    }
    
    /// Physical address of the building
    public let address: DVFAddress?
    
    /// Building specifications
    public let specifications: DVFBuildingSpecifications
    
    /// Current configuration for the building
    public let configuration: DVFBuildingConfiguration
    
    // MARK: - Timestamps
    
    /// When the building was created
    public let createdAt: Date
    
    /// When the building was last modified
    public let updatedAt: Date
    
    /// When the building was last accessed
    public var lastAccessedAt: Date?
    
    // MARK: - Initialization
    
    /// Initialize a new building
    /// - Parameters:
    ///   - id: Unique identifier (auto-generated if nil)
    ///   - name: Name of the building
    ///   - description: Optional description
    ///   - buildingType: Type of building
    ///   - status: Current status
    ///   - facilityID: ID of the parent facility
    ///   - address: Physical address
    ///   - specifications: Building specifications
    ///   - configuration: Building configuration
    public init(
        id: String? = nil,
        name: String,
        description: String? = nil,
        buildingType: DVFBuildingType,
        status: DVFBuildingStatus = .active,
        facilityID: String,
        address: DVFAddress? = nil,
        specifications: DVFBuildingSpecifications,
        configuration: DVFBuildingConfiguration = DVFBuildingConfiguration.default
    ) {
        self.id = id ?? Self.generateID(for: .building)
        self.name = name
        self.description = description
        self.buildingType = buildingType
        self.status = status
        self.facilityID = facilityID
        self.parentID = facilityID
        self.address = address
        self.specifications = specifications
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
        
        if let error = Self.validateRequiredString(facilityID, fieldName: "facilityID") {
            errors.append(error)
        }
        
        // Validate specifications
        errors.append(contentsOf: specifications.validate())
        
        // Validate configuration
        errors.append(contentsOf: configuration.validate())
        
        return errors
    }
    
    // MARK: - Convenience Methods
    
    /// Check if the building is operational
    public var isOperational: Bool {
        return status.isOperational
    }
    
    /// Get the building's full address as a formatted string
    public var formattedAddress: String {
        return address?.formattedAddress ?? "No address specified"
    }
    
    /// Get the building's capacity information
    public var capacityInfo: String {
        return "\(specifications.totalArea) sq ft, \(specifications.numberOfFloors) floors"
    }
}

/// Types of buildings in the system
public enum DVFBuildingType: String, CaseIterable, Codable {
    case laboratory = "laboratory"
    case office = "office"
    case storage = "storage"
    case animalHousing = "animal_housing"
    case support = "support"
    case mixed = "mixed"
    case other = "other"
    
    /// Human-readable description of the building type
    public var description: String {
        switch self {
        case .laboratory: return "Laboratory"
        case .office: return "Office"
        case .storage: return "Storage"
        case .animalHousing: return "Animal Housing"
        case .support: return "Support"
        case .mixed: return "Mixed Purpose"
        case .other: return "Other"
        }
    }
}

/// Status of a building
public enum DVFBuildingStatus: String, CaseIterable, Codable {
    case active = "active"
    case inactive = "inactive"
    case maintenance = "maintenance"
    case renovation = "renovation"
    case emergency = "emergency"
    case decommissioned = "decommissioned"
    
    /// Human-readable description of the building status
    public var description: String {
        switch self {
        case .active: return "Active"
        case .inactive: return "Inactive"
        case .maintenance: return "Under Maintenance"
        case .renovation: return "Under Renovation"
        case .emergency: return "Emergency Mode"
        case .decommissioned: return "Decommissioned"
        }
    }
    
    /// Whether the building is operational
    public var isOperational: Bool {
        switch self {
        case .active, .maintenance:
            return true
        case .inactive, .renovation, .emergency, .decommissioned:
            return false
        }
    }
}

/// Specifications for a building
public struct DVFBuildingSpecifications: Codable, DVFValidatable {
    public let totalArea: Double // in square feet
    public let numberOfFloors: Int
    public let yearBuilt: Int?
    public let lastRenovation: Int?
    public let constructionType: DVFConstructionType
    public let heatingSystem: String?
    public let coolingSystem: String?
    public let ventilationSystem: String?
    public let securitySystem: String?
    
    public init(
        totalArea: Double,
        numberOfFloors: Int,
        yearBuilt: Int? = nil,
        lastRenovation: Int? = nil,
        constructionType: DVFConstructionType,
        heatingSystem: String? = nil,
        coolingSystem: String? = nil,
        ventilationSystem: String? = nil,
        securitySystem: String? = nil
    ) {
        self.totalArea = totalArea
        self.numberOfFloors = numberOfFloors
        self.yearBuilt = yearBuilt
        self.lastRenovation = lastRenovation
        self.constructionType = constructionType
        self.heatingSystem = heatingSystem
        self.coolingSystem = coolingSystem
        self.ventilationSystem = ventilationSystem
        self.securitySystem = securitySystem
    }
    
    public func validate() -> [DVFValidationError] {
        var errors: [DVFValidationError] = []
        
        // Validate area
        if let error = Self.validateNumericRange(totalArea, min: 100.0, max: 1000000.0, fieldName: "totalArea") {
            errors.append(error)
        }
        
        // Validate number of floors
        if let error = Self.validateNumericRange(numberOfFloors, min: 1, max: 100, fieldName: "numberOfFloors") {
            errors.append(error)
        }
        
        // Validate year built
        if let yearBuilt = yearBuilt {
            let currentYear = Calendar.current.component(.year, from: Date())
            if let error = Self.validateNumericRange(yearBuilt, min: 1800, max: currentYear, fieldName: "yearBuilt") {
                errors.append(error)
            }
        }
        
        // Validate last renovation
        if let lastRenovation = lastRenovation {
            let currentYear = Calendar.current.component(.year, from: Date())
            if let error = Self.validateNumericRange(lastRenovation, min: 1800, max: currentYear, fieldName: "lastRenovation") {
                errors.append(error)
            }
        }
        
        return errors
    }
}

/// Types of construction
public enum DVFConstructionType: String, CaseIterable, Codable {
    case concrete = "concrete"
    case steel = "steel"
    case wood = "wood"
    case masonry = "masonry"
    case mixed = "mixed"
    case other = "other"
    
    /// Human-readable description of the construction type
    public var description: String {
        switch self {
        case .concrete: return "Concrete"
        case .steel: return "Steel"
        case .wood: return "Wood"
        case .masonry: return "Masonry"
        case .mixed: return "Mixed"
        case .other: return "Other"
        }
    }
} 