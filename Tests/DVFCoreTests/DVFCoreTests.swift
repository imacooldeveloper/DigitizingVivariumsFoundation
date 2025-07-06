import XCTest
@testable import DVFCore

final class DVFCoreTests: XCTestCase {
    
    func testDVFIdentifiableProtocol() {
        // Test ID generation
        let facilityID = DVFIdentifiable.generateID(for: .facility)
        XCTAssertTrue(DVFIdentifiable.isValidID(facilityID, for: .facility))
        
        let buildingID = DVFIdentifiable.generateID(for: .building)
        XCTAssertTrue(DVFIdentifiable.isValidID(buildingID, for: .building))
        
        // Test invalid IDs
        XCTAssertFalse(DVFIdentifiable.isValidID("invalid_id", for: .facility))
        XCTAssertFalse(DVFIdentifiable.isValidID("facility_123", for: .facility))
    }
    
    func testDVFEntityType() {
        // Test facility type
        XCTAssertEqual(DVFEntityType.facility.description, "Facility")
        XCTAssertTrue(DVFEntityType.facility.supportsHierarchy)
        XCTAssertFalse(DVFEntityType.facility.requiresFacilityScope)
        
        // Test building type
        XCTAssertEqual(DVFEntityType.building.description, "Building")
        XCTAssertTrue(DVFEntityType.building.supportsHierarchy)
        XCTAssertTrue(DVFEntityType.building.requiresFacilityScope)
    }
    
    func testDVFFacilityCreation() {
        let contactInfo = DVFContactInfo(
            email: "test@facility.com",
            phone: "+1-555-0123"
        )
        
        let address = DVFAddress(
            street: "123 Test Street",
            city: "Test City",
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
        
        let facility = DVFFacility(
            name: "Test Facility",
            description: "A test facility",
            facilityType: .research,
            contactInfo: contactInfo,
            address: address,
            operatingHours: operatingHours
        )
        
        // Test basic properties
        XCTAssertEqual(facility.name, "Test Facility")
        XCTAssertEqual(facility.facilityType, .research)
        XCTAssertEqual(facility.entityType, .facility)
        XCTAssertTrue(DVFIdentifiable.isValidID(facility.id, for: .facility))
        
        // Test validation
        let errors = facility.validate()
        XCTAssertTrue(errors.isEmpty, "Facility should be valid: \(errors)")
    }
    
    func testDVFFacilityValidation() {
        // Test invalid facility (missing email)
        let invalidContactInfo = DVFContactInfo(
            email: "", // Invalid empty email
            phone: "+1-555-0123"
        )
        
        let address = DVFAddress(
            street: "123 Test Street",
            city: "Test City",
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
        
        let invalidFacility = DVFFacility(
            name: "Test Facility",
            facilityType: .research,
            contactInfo: invalidContactInfo,
            address: address,
            operatingHours: operatingHours
        )
        
        let errors = invalidFacility.validate()
        XCTAssertFalse(errors.isEmpty, "Facility should have validation errors")
        XCTAssertTrue(errors.contains { $0.localizedDescription.contains("email") })
    }
    
    func testDVFBuildingCreation() {
        let specifications = DVFBuildingSpecifications(
            totalArea: 10000.0,
            numberOfFloors: 3,
            constructionType: .concrete
        )
        
        let building = DVFBuilding(
            name: "Test Building",
            description: "A test building",
            buildingType: .laboratory,
            facilityID: "facility_1234567890_1234",
            specifications: specifications
        )
        
        // Test basic properties
        XCTAssertEqual(building.name, "Test Building")
        XCTAssertEqual(building.buildingType, .laboratory)
        XCTAssertEqual(building.entityType, .building)
        XCTAssertEqual(building.facilityID, "facility_1234567890_1234")
        XCTAssertTrue(DVFIdentifiable.isValidID(building.id, for: .building))
        
        // Test validation
        let errors = building.validate()
        XCTAssertTrue(errors.isEmpty, "Building should be valid: \(errors)")
    }
    
    func testDVFConfigurationManager() {
        let manager = DVFConfigurationManager.shared
        
        // Test storing and retrieving configuration
        let config = DVFFacilityConfiguration.default
        manager.store(config, forKey: "test_config")
        
        let retrievedConfig: DVFFacilityConfiguration? = manager.retrieve(forKey: "test_config")
        XCTAssertNotNil(retrievedConfig)
        XCTAssertEqual(retrievedConfig?.configurationType, .facility)
        
        // Test removing configuration
        manager.remove(forKey: "test_config")
        let removedConfig: DVFFacilityConfiguration? = manager.retrieve(forKey: "test_config")
        XCTAssertNil(removedConfig)
    }
    
    func testDVFValidationUtilities() {
        // Test required string validation
        let requiredError = DVFValidatable.validateRequiredString("", fieldName: "test")
        XCTAssertNotNil(requiredError)
        XCTAssertEqual(requiredError?.localizedDescription, "Required field 'test' is missing")
        
        let validRequired = DVFValidatable.validateRequiredString("valid", fieldName: "test")
        XCTAssertNil(validRequired)
        
        // Test numeric range validation
        let rangeError = DVFValidatable.validateNumericRange(150, min: 1, max: 100, fieldName: "test")
        XCTAssertNotNil(rangeError)
        XCTAssertEqual(rangeError?.localizedDescription, "Field 'test' value '150' is out of range. Valid range: 1 to 100")
        
        let validRange = DVFValidatable.validateNumericRange(50, min: 1, max: 100, fieldName: "test")
        XCTAssertNil(validRange)
    }
    
    func testDVFCoreError() {
        let error = DVFCoreError.facilityNotFound("test_facility")
        XCTAssertEqual(error.localizedDescription, "Facility not found: test_facility")
        XCTAssertTrue(error.isRecoverable)
        
        let validationError = DVFCoreError.validationFailed([
            DVFValidationError.requiredFieldMissing("test_field")
        ])
        XCTAssertTrue(validationError.localizedDescription.contains("Validation failed"))
        XCTAssertTrue(validationError.isRecoverable)
    }
    
    func testDVFFacilityStatus() {
        XCTAssertTrue(DVFFacilityStatus.active.isOperational)
        XCTAssertTrue(DVFFacilityStatus.maintenance.isOperational)
        XCTAssertFalse(DVFFacilityStatus.inactive.isOperational)
        XCTAssertFalse(DVFFacilityStatus.emergency.isOperational)
        XCTAssertFalse(DVFFacilityStatus.decommissioned.isOperational)
    }
    
    func testDVFBuildingStatus() {
        XCTAssertTrue(DVFBuildingStatus.active.isOperational)
        XCTAssertTrue(DVFBuildingStatus.maintenance.isOperational)
        XCTAssertFalse(DVFBuildingStatus.inactive.isOperational)
        XCTAssertFalse(DVFBuildingStatus.renovation.isOperational)
        XCTAssertFalse(DVFBuildingStatus.emergency.isOperational)
        XCTAssertFalse(DVFBuildingStatus.decommissioned.isOperational)
    }
    
    func testDVFOperatingHours() {
        let operatingHours = DVFOperatingHours(
            monday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 8)), closeTime: Calendar.current.date(from: DateComponents(hour: 18))),
            tuesday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 8)), closeTime: Calendar.current.date(from: DateComponents(hour: 18))),
            wednesday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 8)), closeTime: Calendar.current.date(from: DateComponents(hour: 18))),
            thursday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 8)), closeTime: Calendar.current.date(from: DateComponents(hour: 18))),
            friday: DVFDayHours(isOpen: true, openTime: Calendar.current.date(from: DateComponents(hour: 8)), closeTime: Calendar.current.date(from: DateComponents(hour: 18))),
            saturday: DVFDayHours(isOpen: false),
            sunday: DVFDayHours(isOpen: false)
        )
        
        let errors = operatingHours.validate()
        XCTAssertTrue(errors.isEmpty, "Operating hours should be valid: \(errors)")
    }
    
    func testDVFDayHours() {
        let openHours = DVFDayHours(
            isOpen: true,
            openTime: Calendar.current.date(from: DateComponents(hour: 8)),
            closeTime: Calendar.current.date(from: DateComponents(hour: 18))
        )
        
        let closedHours = DVFDayHours(isOpen: false)
        
        let openErrors = openHours.validate()
        XCTAssertTrue(openErrors.isEmpty, "Open hours should be valid: \(openErrors)")
        
        let closedErrors = closedHours.validate()
        XCTAssertTrue(closedErrors.isEmpty, "Closed hours should be valid: \(closedErrors)")
    }
} 