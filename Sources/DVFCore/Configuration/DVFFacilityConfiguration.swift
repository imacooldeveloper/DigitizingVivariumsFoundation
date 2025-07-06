import Foundation

/// Configuration settings for a facility.
///
/// This configuration object contains all the customizable settings
/// that control how a facility operates within the vivarium digitization system.
public struct DVFFacilityConfiguration: DVFConfiguration, Codable {
    
    // MARK: - DVFConfiguration
    
    public let configurationType: DVFConfigurationType = .facility
    public let version: String = "1.0.0"
    public let isDefault: Bool
    
    // MARK: - General Settings
    
    /// Whether the facility requires approval for animal transfers
    public let requiresTransferApproval: Bool
    
    /// Whether the facility requires approval for equipment maintenance
    public let requiresMaintenanceApproval: Bool
    
    /// Maximum number of animals allowed in the facility
    public let maxAnimals: Int?
    
    /// Maximum number of users allowed in the facility
    public let maxUsers: Int?
    
    /// Whether the facility supports real-time monitoring
    public let supportsRealTimeMonitoring: Bool
    
    /// Whether the facility supports automated reporting
    public let supportsAutomatedReporting: Bool
    
    // MARK: - Security Settings
    
    /// Whether the facility requires two-factor authentication
    public let requiresTwoFactorAuth: Bool
    
    /// Minimum password length for facility users
    public let minPasswordLength: Int
    
    /// Whether the facility enforces password complexity
    public let enforcesPasswordComplexity: Bool
    
    /// Session timeout in minutes
    public let sessionTimeoutMinutes: Int
    
    /// Whether the facility logs all user actions
    public let logsUserActions: Bool
    
    // MARK: - Notification Settings
    
    /// Whether the facility sends email notifications
    public let sendsEmailNotifications: Bool
    
    /// Whether the facility sends push notifications
    public let sendsPushNotifications: Bool
    
    /// Whether the facility sends SMS notifications
    public let sendsSMSNotifications: Bool
    
    /// Default notification recipients
    public let defaultNotificationRecipients: [String]
    
    // MARK: - Data Retention Settings
    
    /// How long to retain audit logs (in days)
    public let auditLogRetentionDays: Int
    
    /// How long to retain animal records (in days)
    public let animalRecordRetentionDays: Int
    
    /// How long to retain equipment records (in days)
    public let equipmentRecordRetentionDays: Int
    
    /// Whether to automatically archive old records
    public let autoArchiveRecords: Bool
    
    // MARK: - UI Settings
    
    /// Default theme for the facility
    public let defaultTheme: DVFThemeType
    
    /// Whether to show advanced features by default
    public let showAdvancedFeatures: Bool
    
    /// Whether to show debug information
    public let showDebugInfo: Bool
    
    /// Default language for the facility
    public let defaultLanguage: DVFLanguage
    
    // MARK: - Initialization
    
    /// Initialize a new facility configuration
    /// - Parameters:
    ///   - isDefault: Whether this is the default configuration
    ///   - requiresTransferApproval: Whether transfer approval is required
    ///   - requiresMaintenanceApproval: Whether maintenance approval is required
    ///   - maxAnimals: Maximum number of animals allowed
    ///   - maxUsers: Maximum number of users allowed
    ///   - supportsRealTimeMonitoring: Whether real-time monitoring is supported
    ///   - supportsAutomatedReporting: Whether automated reporting is supported
    ///   - requiresTwoFactorAuth: Whether two-factor authentication is required
    ///   - minPasswordLength: Minimum password length
    ///   - enforcesPasswordComplexity: Whether password complexity is enforced
    ///   - sessionTimeoutMinutes: Session timeout in minutes
    ///   - logsUserActions: Whether user actions are logged
    ///   - sendsEmailNotifications: Whether email notifications are sent
    ///   - sendsPushNotifications: Whether push notifications are sent
    ///   - sendsSMSNotifications: Whether SMS notifications are sent
    ///   - defaultNotificationRecipients: Default notification recipients
    ///   - auditLogRetentionDays: Audit log retention period
    ///   - animalRecordRetentionDays: Animal record retention period
    ///   - equipmentRecordRetentionDays: Equipment record retention period
    ///   - autoArchiveRecords: Whether to auto-archive records
    ///   - defaultTheme: Default theme
    ///   - showAdvancedFeatures: Whether to show advanced features
    ///   - showDebugInfo: Whether to show debug info
    ///   - defaultLanguage: Default language
    public init(
        isDefault: Bool = false,
        requiresTransferApproval: Bool = true,
        requiresMaintenanceApproval: Bool = true,
        maxAnimals: Int? = nil,
        maxUsers: Int? = nil,
        supportsRealTimeMonitoring: Bool = true,
        supportsAutomatedReporting: Bool = true,
        requiresTwoFactorAuth: Bool = false,
        minPasswordLength: Int = 8,
        enforcesPasswordComplexity: Bool = true,
        sessionTimeoutMinutes: Int = 480, // 8 hours
        logsUserActions: Bool = true,
        sendsEmailNotifications: Bool = true,
        sendsPushNotifications: Bool = true,
        sendsSMSNotifications: Bool = false,
        defaultNotificationRecipients: [String] = [],
        auditLogRetentionDays: Int = 2555, // 7 years
        animalRecordRetentionDays: Int = 2555, // 7 years
        equipmentRecordRetentionDays: Int = 1825, // 5 years
        autoArchiveRecords: Bool = true,
        defaultTheme: DVFThemeType = .standard,
        showAdvancedFeatures: Bool = false,
        showDebugInfo: Bool = false,
        defaultLanguage: DVFLanguage = .english
    ) {
        self.isDefault = isDefault
        self.requiresTransferApproval = requiresTransferApproval
        self.requiresMaintenanceApproval = requiresMaintenanceApproval
        self.maxAnimals = maxAnimals
        self.maxUsers = maxUsers
        self.supportsRealTimeMonitoring = supportsRealTimeMonitoring
        self.supportsAutomatedReporting = supportsAutomatedReporting
        self.requiresTwoFactorAuth = requiresTwoFactorAuth
        self.minPasswordLength = minPasswordLength
        self.enforcesPasswordComplexity = enforcesPasswordComplexity
        self.sessionTimeoutMinutes = sessionTimeoutMinutes
        self.logsUserActions = logsUserActions
        self.sendsEmailNotifications = sendsEmailNotifications
        self.sendsPushNotifications = sendsPushNotifications
        self.sendsSMSNotifications = sendsSMSNotifications
        self.defaultNotificationRecipients = defaultNotificationRecipients
        self.auditLogRetentionDays = auditLogRetentionDays
        self.animalRecordRetentionDays = animalRecordRetentionDays
        self.equipmentRecordRetentionDays = equipmentRecordRetentionDays
        self.autoArchiveRecords = autoArchiveRecords
        self.defaultTheme = defaultTheme
        self.showAdvancedFeatures = showAdvancedFeatures
        self.showDebugInfo = showDebugInfo
        self.defaultLanguage = defaultLanguage
    }
    
    // MARK: - DVFValidatable
    
    public func validate() -> [DVFValidationError] {
        var errors: [DVFValidationError] = []
        
        // Validate password length
        if let error = Self.validateNumericRange(minPasswordLength, min: 6, max: 32, fieldName: "minPasswordLength") {
            errors.append(error)
        }
        
        // Validate session timeout
        if let error = Self.validateNumericRange(sessionTimeoutMinutes, min: 15, max: 1440, fieldName: "sessionTimeoutMinutes") {
            errors.append(error)
        }
        
        // Validate retention periods
        if let error = Self.validateNumericRange(auditLogRetentionDays, min: 30, max: 3650, fieldName: "auditLogRetentionDays") {
            errors.append(error)
        }
        
        if let error = Self.validateNumericRange(animalRecordRetentionDays, min: 365, max: 3650, fieldName: "animalRecordRetentionDays") {
            errors.append(error)
        }
        
        if let error = Self.validateNumericRange(equipmentRecordRetentionDays, min: 365, max: 3650, fieldName: "equipmentRecordRetentionDays") {
            errors.append(error)
        }
        
        // Validate max animals
        if let maxAnimals = maxAnimals {
            if let error = Self.validateNumericRange(maxAnimals, min: 1, max: 10000, fieldName: "maxAnimals") {
                errors.append(error)
            }
        }
        
        // Validate max users
        if let maxUsers = maxUsers {
            if let error = Self.validateNumericRange(maxUsers, min: 1, max: 1000, fieldName: "maxUsers") {
                errors.append(error)
            }
        }
        
        // Validate notification recipients
        for (index, recipient) in defaultNotificationRecipients.enumerated() {
            if let error = Self.validateStringPattern(recipient, pattern: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", fieldName: "defaultNotificationRecipients[\(index)]") {
                errors.append(error)
            }
        }
        
        return errors
    }
    
    // MARK: - Static Methods
    
    /// Get the default facility configuration
    public static var `default`: DVFFacilityConfiguration {
        return DVFFacilityConfiguration(isDefault: true)
    }
    
    /// Get a minimal facility configuration for testing
    public static var minimal: DVFFacilityConfiguration {
        return DVFFacilityConfiguration(
            isDefault: false,
            requiresTransferApproval: false,
            requiresMaintenanceApproval: false,
            supportsRealTimeMonitoring: false,
            supportsAutomatedReporting: false,
            requiresTwoFactorAuth: false,
            minPasswordLength: 6,
            enforcesPasswordComplexity: false,
            sessionTimeoutMinutes: 60,
            logsUserActions: false,
            sendsEmailNotifications: false,
            sendsPushNotifications: false,
            sendsSMSNotifications: false,
            auditLogRetentionDays: 30,
            animalRecordRetentionDays: 365,
            equipmentRecordRetentionDays: 365,
            autoArchiveRecords: false,
            showAdvancedFeatures: false,
            showDebugInfo: true
        )
    }
    
    /// Get a secure facility configuration
    public static var secure: DVFFacilityConfiguration {
        return DVFFacilityConfiguration(
            isDefault: false,
            requiresTransferApproval: true,
            requiresMaintenanceApproval: true,
            supportsRealTimeMonitoring: true,
            supportsAutomatedReporting: true,
            requiresTwoFactorAuth: true,
            minPasswordLength: 12,
            enforcesPasswordComplexity: true,
            sessionTimeoutMinutes: 240, // 4 hours
            logsUserActions: true,
            sendsEmailNotifications: true,
            sendsPushNotifications: true,
            sendsSMSNotifications: true,
            auditLogRetentionDays: 3650, // 10 years
            animalRecordRetentionDays: 3650, // 10 years
            equipmentRecordRetentionDays: 3650, // 10 years
            autoArchiveRecords: true,
            showAdvancedFeatures: true,
            showDebugInfo: false
        )
    }
}

/// Types of themes available for facilities
public enum DVFThemeType: String, CaseIterable, Codable {
    case standard = "standard"
    case dark = "dark"
    case light = "light"
    case highContrast = "highContrast"
    case custom = "custom"
    
    /// Human-readable description of the theme
    public var description: String {
        switch self {
        case .standard: return "Standard"
        case .dark: return "Dark"
        case .light: return "Light"
        case .highContrast: return "High Contrast"
        case .custom: return "Custom"
        }
    }
}

/// Languages supported by the system
public enum DVFLanguage: String, CaseIterable, Codable {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case chinese = "zh"
    case japanese = "ja"
    case korean = "ko"
    
    /// Human-readable name of the language
    public var name: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .chinese: return "中文"
        case .japanese: return "日本語"
        case .korean: return "한국어"
        }
    }
    
    /// Localized name of the language
    public var localizedName: String {
        return NSLocalizedString(name, comment: "Language name")
    }
}

public class DVFUIService: ObservableObject {
    public let themeManager: DVFThemeManager
    public let componentLibrary: DVFComponentLibrary

    public init() {
        self.themeManager = DVFThemeManager()
        self.componentLibrary = DVFComponentLibrary()
    }

    public func configure(with config: DVFFirebaseConfiguration) async throws {
        // Placeholder implementation
    }

    public func reset() async {
        // Placeholder implementation
    }
}

public class DVFThemeManager: ObservableObject {
    public init() {}
}

public class DVFComponentLibrary: ObservableObject {
    public init() {}
} 
