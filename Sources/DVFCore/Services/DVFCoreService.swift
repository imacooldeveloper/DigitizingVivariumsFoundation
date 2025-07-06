import Foundation

/// Main service for managing core functionality in the vivarium digitization system.
///
/// This service coordinates between different core components and provides
/// a centralized interface for core operations.
public final class DVFCoreService: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Whether the core service is initialized
    @Published public private(set) var isInitialized = false
    
    /// Current initialization status
    @Published public private(set) var initializationStatus: DVFInitializationStatus = .notStarted
    
    /// Current error state
    @Published public private(set) var currentError: DVFCoreError?
    
    // MARK: - Services
    
    /// Facility management service
    public let facilityManager: DVFFacilityManager
    
    /// Configuration management service
    public let configurationManager: DVFConfigurationManager
    
    // MARK: - Private Properties
    
    private var firebaseConfig: DVFFirebaseConfiguration?
    private let queue = DispatchQueue(label: "com.dvf.core", attributes: .concurrent)
    
    // MARK: - Initialization
    
    /// Initialize the core service
    public init() {
        self.facilityManager = DVFFacilityManager()
        self.configurationManager = DVFConfigurationManager.shared
    }
    
    /// Configure the core service with Firebase configuration
    /// - Parameter config: Firebase configuration
    public func configure(with config: DVFFirebaseConfiguration) async throws {
        await setInitializationStatus(.configuring)
        
        do {
            // Store the configuration
            self.firebaseConfig = config
            
            // Initialize facility manager
            try await facilityManager.configure(with: config)
            
            // Load default configurations
            try await loadDefaultConfigurations()
            
            // Mark as initialized
            await setInitializationStatus(.completed)
            await setInitialized(true)
            
        } catch {
            await setInitializationStatus(.failed)
            await setError(DVFCoreError.initializationFailed(error.localizedDescription))
            throw error
        }
    }
    
    /// Reset the core service to its initial state
    public func reset() async {
        await setInitializationStatus(.resetting)
        
        // Reset services
        await facilityManager.reset()
        
        // Clear configurations
        configurationManager.clearAll()
        
        // Clear Firebase config
        firebaseConfig = nil
        
        // Reset state
        await setInitializationStatus(.notStarted)
        await setInitialized(false)
        await setError(nil)
    }
    
    // MARK: - Private Methods
    
    private func loadDefaultConfigurations() async throws {
        // Load default facility configuration
        let defaultFacilityConfig = DVFFacilityConfiguration.default
        configurationManager.store(defaultFacilityConfig, forKey: "default_facility_config")
        
        // Load minimal configuration for testing
        let minimalConfig = DVFFacilityConfiguration.minimal
        configurationManager.store(minimalConfig, forKey: "minimal_facility_config")
        
        // Load secure configuration
        let secureConfig = DVFFacilityConfiguration.secure
        configurationManager.store(secureConfig, forKey: "secure_facility_config")
    }
    
    @MainActor
    private func setInitializationStatus(_ status: DVFInitializationStatus) {
        initializationStatus = status
    }
    
    @MainActor
    private func setInitialized(_ initialized: Bool) {
        isInitialized = initialized
    }
    
    @MainActor
    private func setError(_ error: DVFCoreError?) {
        currentError = error
    }
    
    // MARK: - Utility Methods
    
    /// Get the current Firebase configuration
    public var currentFirebaseConfig: DVFFirebaseConfiguration? {
        return firebaseConfig
    }
    
    /// Check if the service is ready for operations
    public var isReady: Bool {
        return isInitialized && initializationStatus == .completed
    }
    
    /// Get a configuration by key
    /// - Parameter key: Configuration key
    /// - Returns: Configuration if found
    public func getConfiguration<T: DVFConfiguration>(forKey key: String) -> T? {
        return configurationManager.retrieve(forKey: key)
    }
    
    /// Store a configuration
    /// - Parameters:
    ///   - configuration: Configuration to store
    ///   - key: Key to store under
    public func storeConfiguration<T: DVFConfiguration>(_ configuration: T, forKey key: String) {
        configurationManager.store(configuration, forKey: key)
    }
    
    /// Remove a configuration
    /// - Parameter key: Key to remove
    public func removeConfiguration(forKey key: String) {
        configurationManager.remove(forKey: key)
    }
    
    /// Get all configuration keys
    public var allConfigurationKeys: [String] {
        return configurationManager.allKeys
    }
}

/// Status of the initialization process
public enum DVFInitializationStatus: String, CaseIterable {
    case notStarted = "not_started"
    case configuring = "configuring"
    case completed = "completed"
    case failed = "failed"
    case resetting = "resetting"
    
    /// Human-readable description of the status
    public var description: String {
        switch self {
        case .notStarted: return "Not Started"
        case .configuring: return "Configuring"
        case .completed: return "Completed"
        case .failed: return "Failed"
        case .resetting: return "Resetting"
        }
    }
    
    /// Whether the initialization is in progress
    public var isInProgress: Bool {
        switch self {
        case .configuring, .resetting:
            return true
        case .notStarted, .completed, .failed:
            return false
        }
    }
    
    /// Whether the initialization is complete
    public var isComplete: Bool {
        return self == .completed
    }
    
    /// Whether the initialization failed
    public var isFailed: Bool {
        return self == .failed
    }
} 