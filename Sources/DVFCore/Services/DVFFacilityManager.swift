import Foundation

/// Service for managing facilities in the vivarium digitization system.
///
/// This service provides operations for creating, updating, and managing
/// facilities and their associated data.
public final class DVFFacilityManager: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Currently loaded facilities
    @Published public private(set) var facilities: [DVFFacility] = []
    
    /// Current loading state
    @Published public private(set) var isLoading = false
    
    /// Current error state
    @Published public private(set) var currentError: DVFCoreError?
    
    // MARK: - Private Properties
    
    private var firebaseConfig: DVFFirebaseConfiguration?
    private let queue = DispatchQueue(label: "com.dvf.facility", attributes: .concurrent)
    
    // MARK: - Initialization
    
    /// Initialize the facility manager
    public init() {}
    
    /// Configure the facility manager with Firebase configuration
    /// - Parameter config: Firebase configuration
    public func configure(with config: DVFFirebaseConfiguration) async throws {
        self.firebaseConfig = config
        
        // Load initial facilities
        try await loadFacilities()
    }
    
    /// Reset the facility manager to its initial state
    public func reset() async {
        await setFacilities([])
        await setLoading(false)
        await setError(nil)
        firebaseConfig = nil
    }
    
    // MARK: - Facility Operations
    
    /// Create a new facility
    /// - Parameter facility: The facility to create
    /// - Returns: The created facility
    public func createFacility(_ facility: DVFFacility) async throws -> DVFFacility {
        // Validate the facility
        let errors = facility.validate()
        if !errors.isEmpty {
            throw DVFCoreError.validationFailed(errors)
        }
        
        // Check if facility already exists
        if facilities.contains(where: { $0.id == facility.id }) {
            throw DVFCoreError.entityAlreadyExists("facility", facility.id)
        }
        
        // In a real implementation, this would save to Firebase
        // For now, we'll just add to the local array
        var newFacility = facility
        await addFacility(newFacility)
        
        return newFacility
    }
    
    /// Update an existing facility
    /// - Parameter facility: The updated facility
    /// - Returns: The updated facility
    public func updateFacility(_ facility: DVFFacility) async throws -> DVFFacility {
        // Validate the facility
        let errors = facility.validate()
        if !errors.isEmpty {
            throw DVFCoreError.validationFailed(errors)
        }
        
        // Check if facility exists
        guard let index = facilities.firstIndex(where: { $0.id == facility.id }) else {
            throw DVFCoreError.entityNotFound("facility", facility.id)
        }
        
        // In a real implementation, this would update in Firebase
        // For now, we'll just update the local array
        await updateFacilityAtIndex(index, with: facility)
        
        return facility
    }
    
    /// Delete a facility
    /// - Parameter facilityID: The ID of the facility to delete
    public func deleteFacility(_ facilityID: String) async throws {
        // Check if facility exists
        guard let index = facilities.firstIndex(where: { $0.id == facilityID }) else {
            throw DVFCoreError.entityNotFound("facility", facilityID)
        }
        
        // In a real implementation, this would delete from Firebase
        // For now, we'll just remove from the local array
        await removeFacilityAtIndex(index)
    }
    
    /// Get a facility by ID
    /// - Parameter facilityID: The ID of the facility to retrieve
    /// - Returns: The facility if found
    public func getFacility(_ facilityID: String) -> DVFFacility? {
        return facilities.first { $0.id == facilityID }
    }
    
    /// Get all facilities
    /// - Returns: Array of all facilities
    public func getAllFacilities() -> [DVFFacility] {
        return facilities
    }
    
    /// Get facilities by type
    /// - Parameter type: The type of facilities to retrieve
    /// - Returns: Array of facilities of the specified type
    public func getFacilities(ofType type: DVFFacilityType) -> [DVFFacility] {
        return facilities.filter { $0.facilityType == type }
    }
    
    /// Get operational facilities
    /// - Returns: Array of operational facilities
    public func getOperationalFacilities() -> [DVFFacility] {
        return facilities.filter { $0.status.isOperational }
    }
    
    /// Search facilities by name
    /// - Parameter query: The search query
    /// - Returns: Array of facilities matching the query
    public func searchFacilities(query: String) -> [DVFFacility] {
        let lowercasedQuery = query.lowercased()
        return facilities.filter { facility in
            facility.name.lowercased().contains(lowercasedQuery) ||
            (facility.description?.lowercased().contains(lowercasedQuery) ?? false)
        }
    }
    
    /// Check if a facility exists
    /// - Parameter facilityID: The ID of the facility to check
    /// - Returns: True if the facility exists
    public func facilityExists(_ facilityID: String) -> Bool {
        return facilities.contains { $0.id == facilityID }
    }
    
    /// Get facility statistics
    /// - Returns: Statistics about all facilities
    public func getFacilityStatistics() -> DVFFacilityStatistics {
        let total = facilities.count
        let operational = facilities.filter { $0.status.isOperational }.count
        let byType = Dictionary(grouping: facilities, by: { $0.facilityType })
            .mapValues { $0.count }
        let byStatus = Dictionary(grouping: facilities, by: { $0.status })
            .mapValues { $0.count }
        
        return DVFFacilityStatistics(
            total: total,
            operational: operational,
            byType: byType,
            byStatus: byStatus
        )
    }
    
    // MARK: - Private Methods
    
    private func loadFacilities() async throws {
        await setLoading(true)
        
        do {
            // In a real implementation, this would load from Firebase
            // For now, we'll create some sample facilities
            let sampleFacilities = createSampleFacilities()
            await setFacilities(sampleFacilities)
            
        } catch {
            await setError(DVFCoreError.databaseError(error.localizedDescription))
            throw error
        }
        
        await setLoading(false)
    }
    
    private func createSampleFacilities() -> [DVFFacility] {
        let contactInfo = DVFContactInfo(
            email: "admin@researchfacility.com",
            phone: "+1-555-0123",
            website: "https://researchfacility.com"
        )
        
        let address = DVFAddress(
            street: "123 Research Drive",
            city: "Science City",
            state: "CA",
            zipCode: "90210",
            country: "USA"
        )
        
        let operatingHours = DVFOperatingHours(
            monday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 8)), closeTime: Calendar.current.date(from: DateComponents(hour: 18))),
            tuesday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 8)), closeTime: Calendar.current.date(from: DateComponents(hour: 18))),
            wednesday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 8)), closeTime: Calendar.current.date(from: DateComponents(hour: 18))),
            thursday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 8)), closeTime: Calendar.current.date(from: DateComponents(hour: 18))),
            friday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 8)), closeTime: Calendar.current.date(from: DateComponents(hour: 18))),
            saturday: DVFDayHours(isOpen: false),
            sunday: DVFDayHours(isOpen: false)
        )
        
        let researchFacility = DVFFacility(
            name: "Main Research Facility",
            description: "Primary research facility for animal studies",
            facilityType: .research,
            contactInfo: contactInfo,
            address: address,
            operatingHours: operatingHours
        )
        
        let breedingFacility = DVFFacility(
            name: "Breeding Center",
            description: "Specialized facility for animal breeding programs",
            facilityType: .breeding,
            contactInfo: contactInfo,
            address: address,
            operatingHours: operatingHours
        )
        
        return [researchFacility, breedingFacility]
    }
    
    @MainActor
    private func setFacilities(_ facilities: [DVFFacility]) {
        self.facilities = facilities
    }
    
    @MainActor
    private func addFacility(_ facility: DVFFacility) {
        facilities.append(facility)
    }
    
    @MainActor
    private func updateFacilityAtIndex(_ index: Int, with facility: DVFFacility) {
        facilities[index] = facility
    }
    
    @MainActor
    private func removeFacilityAtIndex(_ index: Int) {
        facilities.remove(at: index)
    }
    
    @MainActor
    private func setLoading(_ loading: Bool) {
        isLoading = loading
    }
    
    @MainActor
    private func setError(_ error: DVFCoreError?) {
        currentError = error
    }
}

/// Statistics about facilities
public struct DVFFacilityStatistics {
    /// Total number of facilities
    public let total: Int
    
    /// Number of operational facilities
    public let operational: Int
    
    /// Number of facilities by type
    public let byType: [DVFFacilityType: Int]
    
    /// Number of facilities by status
    public let byStatus: [DVFFacilityStatus: Int]
    
    /// Percentage of operational facilities
    public var operationalPercentage: Double {
        guard total > 0 else { return 0 }
        return Double(operational) / Double(total) * 100
    }
    
    /// Most common facility type
    public var mostCommonType: DVFFacilityType? {
        return byType.max(by: { $0.value < $1.value })?.key
    }
    
    /// Most common facility status
    public var mostCommonStatus: DVFFacilityStatus? {
        return byStatus.max(by: { $0.value < $1.value })?.key
    }
} 