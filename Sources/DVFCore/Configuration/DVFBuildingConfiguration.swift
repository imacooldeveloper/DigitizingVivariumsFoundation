import Foundation

/// Configuration settings for a building.
///
/// This configuration object contains all the customizable settings
/// that control how a building operates within the vivarium digitization system.
public struct DVFBuildingConfiguration: DVFConfiguration, Codable {
    
    // MARK: - DVFConfiguration
    
    public let configurationType: DVFConfigurationType = .facility
    public let version: String = "1.0.0"
    public let isDefault: Bool
    
    // MARK: - Access Control Settings
    
    /// Whether the building requires key card access
    public let requiresKeyCardAccess: Bool
    
    /// Whether the building requires visitor registration
    public let requiresVisitorRegistration: Bool
    
    /// Maximum number of visitors allowed at once
    public let maxVisitors: Int?
    
    /// Whether the building has restricted hours
    public let hasRestrictedHours: Bool
    
    /// Building access hours (if restricted)
    public let accessHours: DVFOperatingHours?
    
    // MARK: - Environmental Settings
    
    /// Whether the building has environmental monitoring
    public let hasEnvironmentalMonitoring: Bool
    
    /// Target temperature range (in Celsius)
    public let targetTemperatureRange: ClosedRange<Double>?
    
    /// Target humidity range (in percentage)
    public let targetHumidityRange: ClosedRange<Double>?
    
    /// Whether the building has air filtration
    public let hasAirFiltration: Bool
    
    /// Air exchange rate (per hour)
    public let airExchangeRate: Double?
    
    // MARK: - Safety Settings
    
    /// Whether the building has fire suppression system
    public let hasFireSuppression: Bool
    
    /// Whether the building has emergency lighting
    public let hasEmergencyLighting: Bool
    
    /// Whether the building has emergency exits
    public let hasEmergencyExits: Bool
    
    /// Number of emergency exits
    public let numberOfEmergencyExits: Int?
    
    /// Whether the building has security cameras
    public let hasSecurityCameras: Bool
    
    // MARK: - Maintenance Settings
    
    /// Whether the building requires regular maintenance
    public let requiresRegularMaintenance: Bool
    
    /// Maintenance schedule (in days)
    public let maintenanceScheduleDays: Int?
    
    /// Whether the building has automated maintenance alerts
    public let hasAutomatedMaintenanceAlerts: Bool
    
    // MARK: - Initialization
    
    /// Initialize a new building configuration
    /// - Parameters:
    ///   - isDefault: Whether this is the default configuration
    ///   - requiresKeyCardAccess: Whether key card access is required
    ///   - requiresVisitorRegistration: Whether visitor registration is required
    ///   - maxVisitors: Maximum number of visitors allowed
    ///   - hasRestrictedHours: Whether the building has restricted hours
    ///   - accessHours: Building access hours
    ///   - hasEnvironmentalMonitoring: Whether environmental monitoring is enabled
    ///   - targetTemperatureRange: Target temperature range
    ///   - targetHumidityRange: Target humidity range
    ///   - hasAirFiltration: Whether air filtration is available
    ///   - airExchangeRate: Air exchange rate
    ///   - hasFireSuppression: Whether fire suppression is available
    ///   - hasEmergencyLighting: Whether emergency lighting is available
    ///   - hasEmergencyExits: Whether emergency exits are available
    ///   - numberOfEmergencyExits: Number of emergency exits
    ///   - hasSecurityCameras: Whether security cameras are installed
    ///   - requiresRegularMaintenance: Whether regular maintenance is required
    ///   - maintenanceScheduleDays: Maintenance schedule in days
    ///   - hasAutomatedMaintenanceAlerts: Whether automated maintenance alerts are enabled
    public init(
        isDefault: Bool = false,
        requiresKeyCardAccess: Bool = true,
        requiresVisitorRegistration: Bool = true,
        maxVisitors: Int? = nil,
        hasRestrictedHours: Bool = false,
        accessHours: DVFOperatingHours? = nil,
        hasEnvironmentalMonitoring: Bool = true,
        targetTemperatureRange: ClosedRange<Double>? = 18.0...24.0,
        targetHumidityRange: ClosedRange<Double>? = 30.0...70.0,
        hasAirFiltration: Bool = true,
        airExchangeRate: Double? = 10.0,
        hasFireSuppression: Bool = true,
        hasEmergencyLighting: Bool = true,
        hasEmergencyExits: Bool = true,
        numberOfEmergencyExits: Int? = 2,
        hasSecurityCameras: Bool = true,
        requiresRegularMaintenance: Bool = true,
        maintenanceScheduleDays: Int? = 90,
        hasAutomatedMaintenanceAlerts: Bool = true
    ) {
        self.isDefault = isDefault
        self.requiresKeyCardAccess = requiresKeyCardAccess
        self.requiresVisitorRegistration = requiresVisitorRegistration
        self.maxVisitors = maxVisitors
        self.hasRestrictedHours = hasRestrictedHours
        self.accessHours = accessHours
        self.hasEnvironmentalMonitoring = hasEnvironmentalMonitoring
        self.targetTemperatureRange = targetTemperatureRange
        self.targetHumidityRange = targetHumidityRange
        self.hasAirFiltration = hasAirFiltration
        self.airExchangeRate = airExchangeRate
        self.hasFireSuppression = hasFireSuppression
        self.hasEmergencyLighting = hasEmergencyLighting
        self.hasEmergencyExits = hasEmergencyExits
        self.numberOfEmergencyExits = numberOfEmergencyExits
        self.hasSecurityCameras = hasSecurityCameras
        self.requiresRegularMaintenance = requiresRegularMaintenance
        self.maintenanceScheduleDays = maintenanceScheduleDays
        self.hasAutomatedMaintenanceAlerts = hasAutomatedMaintenanceAlerts
    }
    
    // MARK: - DVFValidatable
    
    public func validate() -> [DVFValidationError] {
        var errors: [DVFValidationError] = []
        
        // Validate max visitors
        if let maxVisitors = maxVisitors {
            if let error = Self.validateNumericRange(maxVisitors, min: 1, max: 1000, fieldName: "maxVisitors") {
                errors.append(error)
            }
        }
        
        // Validate air exchange rate
        if let airExchangeRate = airExchangeRate {
            if let error = Self.validateNumericRange(airExchangeRate, min: 0.1, max: 100.0, fieldName: "airExchangeRate") {
                errors.append(error)
            }
        }
        
        // Validate number of emergency exits
        if let numberOfEmergencyExits = numberOfEmergencyExits {
            if let error = Self.validateNumericRange(numberOfEmergencyExits, min: 1, max: 20, fieldName: "numberOfEmergencyExits") {
                errors.append(error)
            }
        }
        
        // Validate maintenance schedule
        if let maintenanceScheduleDays = maintenanceScheduleDays {
            if let error = Self.validateNumericRange(maintenanceScheduleDays, min: 7, max: 365, fieldName: "maintenanceScheduleDays") {
                errors.append(error)
            }
        }
        
        // Validate temperature range
        if let targetTemperatureRange = targetTemperatureRange {
            if targetTemperatureRange.lowerBound < -50.0 || targetTemperatureRange.upperBound > 100.0 {
                errors.append(.valueOutOfRange("targetTemperatureRange", "\(targetTemperatureRange)", "-50.0 to 100.0"))
            }
        }
        
        // Validate humidity range
        if let targetHumidityRange = targetHumidityRange {
            if targetHumidityRange.lowerBound < 0.0 || targetHumidityRange.upperBound > 100.0 {
                errors.append(.valueOutOfRange("targetHumidityRange", "\(targetHumidityRange)", "0.0 to 100.0"))
            }
        }
        
        // Validate access hours if restricted hours are enabled
        if hasRestrictedHours && accessHours == nil {
            errors.append(.requiredFieldMissing("accessHours"))
        }
        
        return errors
    }
    
    // MARK: - Static Methods
    
    /// Get the default building configuration
    public static var `default`: DVFBuildingConfiguration {
        return DVFBuildingConfiguration(isDefault: true)
    }
    
    /// Get a minimal building configuration for testing
    public static var minimal: DVFBuildingConfiguration {
        return DVFBuildingConfiguration(
            isDefault: false,
            requiresKeyCardAccess: false,
            requiresVisitorRegistration: false,
            hasEnvironmentalMonitoring: false,
            targetTemperatureRange: nil,
            targetHumidityRange: nil,
            hasAirFiltration: false,
            airExchangeRate: nil,
            hasFireSuppression: false,
            hasEmergencyLighting: false,
            hasEmergencyExits: false,
            numberOfEmergencyExits: nil,
            hasSecurityCameras: false,
            requiresRegularMaintenance: false,
            maintenanceScheduleDays: nil,
            hasAutomatedMaintenanceAlerts: false
        )
    }
    
    /// Get a secure building configuration
    public static var secure: DVFBuildingConfiguration {
        return DVFBuildingConfiguration(
            isDefault: false,
            requiresKeyCardAccess: true,
            requiresVisitorRegistration: true,
            maxVisitors: 10,
            hasRestrictedHours: true,
            accessHours: DVFOperatingHours(
                monday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 7)), closeTime: Calendar.current.date(from: DateComponents(hour: 19))),
                tuesday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 7)), closeTime: Calendar.current.date(from: DateComponents(hour: 19))),
                wednesday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 7)), closeTime: Calendar.current.date(from: DateComponents(hour: 19))),
                thursday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 7)), closeTime: Calendar.current.date(from: DateComponents(hour: 19))),
                friday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 7)), closeTime: Calendar.current.date(from: DateComponents(hour: 19))),
                saturday: DVFDayHours(isOpen: false),
                sunday: DVFDayHours(isOpen: false)
            ),
            hasEnvironmentalMonitoring: true,
            targetTemperatureRange: 20.0...22.0,
            targetHumidityRange: 40.0...60.0,
            hasAirFiltration: true,
            airExchangeRate: 15.0,
            hasFireSuppression: true,
            hasEmergencyLighting: true,
            hasEmergencyExits: true,
            numberOfEmergencyExits: 4,
            hasSecurityCameras: true,
            requiresRegularMaintenance: true,
            maintenanceScheduleDays: 30,
            hasAutomatedMaintenanceAlerts: true
        )
    }
} 