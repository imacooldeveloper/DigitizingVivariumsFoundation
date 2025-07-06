/// Configuration manager for handling configuration operations
public final class DVFConfigurationManager: @unchecked Sendable {
    
    /// Shared instance for global configuration management
    public static let shared = DVFConfigurationManager()
    
    private var configurations: [String: Any] = [:]
    private let queue = DispatchQueue(label: "com.dvf.configuration", attributes: .concurrent)
    
    private init() {}
    
    /// Store a configuration
    /// - Parameters:
    ///   - configuration: The configuration to store
    ///   - key: The key to store the configuration under
    public func store<T: DVFConfiguration>(_ configuration: T, forKey key: String) {
        queue.async(flags: .barrier) {
            self.configurations[key] = configuration
        }
    }
    
    /// Retrieve a configuration
    /// - Parameter key: The key to retrieve the configuration for
    /// - Returns: The configuration if found
    public func retrieve<T: DVFConfiguration>(forKey key: String) -> T? {
        return queue.sync {
            return configurations[key] as? T
        }
    }
    
    /// Remove a configuration
    /// - Parameter key: The key to remove the configuration for
    public func remove(forKey key: String) {
        queue.async(flags: .barrier) {
            self.configurations.removeValue(forKey: key)
        }
    }
    
    /// Clear all configurations
    public func clearAll() {
        queue.async(flags: .barrier) {
            self.configurations.removeAll()
        }
    }
    
    /// Get all configuration keys
    public var allKeys: [String] {
        return queue.sync {
            return Array(configurations.keys)
        }
    }
}
