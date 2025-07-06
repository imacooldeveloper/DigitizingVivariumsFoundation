# DigitizingVivariumsFoundation

A comprehensive Swift Package Manager foundation for digitizing vivarium management systems.

## Overview

DigitizingVivariumsFoundation provides a modular architecture for building vivarium digitization applications with support for multi-tenant facilities, real-time data synchronization, and comprehensive user management.

### Features

- **Multi-tenant Architecture**: Secure isolation between different facilities
- **Real-time Synchronization**: Live updates across all connected clients
- **Comprehensive UI Components**: Pre-built SwiftUI components for common vivarium operations
- **Flexible Configuration**: Adaptable to different facility types and requirements
- **Offline Support**: Full functionality without network connectivity
- **Security First**: Role-based access control and audit logging

## Requirements

- iOS 16.0+ / macOS 13.0+ / watchOS 9.0+ / tvOS 16.0+
- Swift 6.0+
- Firebase project with Firestore and Authentication enabled

## Installation

### Swift Package Manager

Add this package to your Xcode project or `Package.swift` dependencies:

```swift
.package(url: "https://github.com/imacooldeveloper/DigitizingVivariumsFoundation.git", from: "1.0.0")
```

### Using in an Xcode App Project

1. Create a new or open an existing Xcode app project (iOS, macOS, etc.).
2. Go to **File > Add Packages...** and enter:
   ```
   https://github.com/imacooldeveloper/DigitizingVivariumsFoundation.git
   ```
3. Import and use the package modules in your app code:
   ```swift
   import DigitizingVivariumsFoundation
   ```
4. Build and run your app on simulator or device. The package provides all core logic, models, and services, but you must use them from an app target.

### Dependencies

The package includes the following dependencies:

- **Firebase iOS SDK** (10.20.0+): For Firestore database and Authentication
- **Swift Collections** (1.0.0+): For enhanced collection types
- **SnapshotTesting** (1.16.0+): For UI testing and visual regression testing

## Quick Start

> **Note:** This package is a library. To run code on a simulator or device, use it from an app target as described above.

### 1. Initialize the Foundation

```swift
import DigitizingVivariumsFoundation

// Initialize the foundation with your Firebase configuration
let foundation = DVFFoundation.shared
await foundation.configure(with: firebaseConfig)
```

### 2. Access Core Services

```swift
// Access facility management
let facilityManager = foundation.facilityManager
let facilities = await facilityManager.fetchFacilities()

// Access authentication
let authService = foundation.authenticationService
let user = await authService.signIn(email: "user@example.com", password: "password")
```

### 3. Create a Facility

```swift
let contactInfo = DVFContactInfo(
    email: "admin@facility.com",
    phone: "+1-555-0123"
)

let address = DVFAddress(
    street: "123 Research Drive",
    city: "Science City",
    state: "CA",
    zipCode: "90210",
    country: "USA"
)

let facility = DVFFacility(
    name: "Main Research Facility",
    description: "Primary research facility for animal studies",
    facilityType: .research,
    contactInfo: contactInfo,
    address: address,
    operatingHours: operatingHours
)

let createdFacility = try await facilityManager.createFacility(facility)
```

## Architecture

The package is organized into four main modules:

### DVFCore

Foundation data models, protocols, and configuration systems.

**Key Components:**
- `DVFFacility`: Top-level organizational unit
- `DVFBuilding`: Physical structures within facilities
- `DVFLocation`: Areas within buildings
- `DVFRoom`: Individual rooms and spaces
- `DVFEquipment`: Equipment and devices
- `DVFAnimal`: Animal records and management
- `DVFUser`: User management and profiles
- `DVFRole`: Role-based access control

**Protocols:**
- `DVFIdentifiable`: Unique identification for all entities
- `DVFTimestamped`: Creation and modification tracking
- `DVFFacilityScoped`: Multi-tenant facility isolation
- `DVFValidatable`: Data validation across all entities
- `DVFConfigurable`: Configuration management

### DVFDatabase

Firebase Firestore integration and data persistence.

**Key Features:**
- Real-time data synchronization
- Offline persistence
- Multi-tenant data isolation
- Batch operations
- Query optimization
- Caching strategies

### DVFAuthentication

User authentication and multi-tenant security.

**Key Features:**
- Firebase Authentication integration
- Role-based access control
- Multi-tenant user isolation
- Session management
- Audit logging
- Two-factor authentication support

### DVFUI

SwiftUI components and theming system.

**Key Components:**
- Facility management views
- Equipment monitoring interfaces
- Animal tracking components
- User management screens
- Configuration wizards
- Dashboard components

## Configuration

### Facility Configuration

```swift
let config = DVFFacilityConfiguration(
    requiresTransferApproval: true,
    requiresMaintenanceApproval: true,
    supportsRealTimeMonitoring: true,
    requiresTwoFactorAuth: false,
    minPasswordLength: 8,
    sessionTimeoutMinutes: 480,
    sendsEmailNotifications: true,
    defaultTheme: .standard
)
```

### Building Configuration

```swift
let buildingConfig = DVFBuildingConfiguration(
    requiresKeyCardAccess: true,
    hasEnvironmentalMonitoring: true,
    targetTemperatureRange: 20.0...24.0,
    targetHumidityRange: 40.0...60.0,
    hasFireSuppression: true,
    hasSecurityCameras: true
)
```

## Data Models

### Facility Hierarchy

```
Facility
├── Building
│   ├── Location
│   │   └── Room
│   │       ├── Equipment
│   │       └── Animal
│   └── Equipment
└── User
```

### Entity Relationships

All entities follow consistent patterns:

- **Identification**: Unique IDs with type prefixes
- **Timestamps**: Creation, modification, and access tracking
- **Validation**: Comprehensive data validation
- **Configuration**: Flexible configuration systems
- **Facility Scoping**: Multi-tenant isolation

## Security

### Multi-Tenant Isolation

- All data is scoped to specific facilities
- Users can only access data from their assigned facilities
- Cross-facility data access is prevented at the database level
- Audit logging tracks all access attempts

### Authentication & Authorization

- Firebase Authentication integration
- Role-based access control (RBAC)
- Custom claims for facility assignment
- Session management with configurable timeouts
- Two-factor authentication support

### Data Protection

- All sensitive data is encrypted at rest
- Network communication uses TLS 1.3
- API keys and secrets are managed securely
- Regular security audits and penetration testing

## Testing

### Unit Testing

```swift
import XCTest
@testable import DigitizingVivariumsFoundation

class DVFFacilityTests: XCTestCase {
    func testFacilityValidation() {
        let facility = DVFFacility(/* test data */)
        let errors = facility.validate()
        XCTAssertTrue(errors.isEmpty)
    }
}
```

### Integration Testing

```swift
class DVFFacilityManagerTests: XCTestCase {
    func testFacilityCreation() async throws {
        let manager = DVFFacilityManager()
        let facility = DVFFacility(/* test data */)
        let created = try await manager.createFacility(facility)
        XCTAssertEqual(created.id, facility.id)
    }
}
```

### UI Testing

```swift
import SnapshotTesting

class DVFFacilityViewTests: XCTestCase {
    func testFacilityViewSnapshot() {
        let view = DVFFacilityView(facility: testFacility)
        assertSnapshot(matching: view, as: .image)
    }
}
```

## Performance

### Optimization Strategies

- **Lazy Loading**: Data is loaded incrementally as needed
- **Caching**: Intelligent caching reduces database queries
- **Pagination**: Large datasets are paginated for performance
- **Background Processing**: Heavy operations run in background
- **Memory Management**: Efficient memory usage and cleanup

### Monitoring

- Real-time performance metrics
- Database query optimization
- Memory usage tracking
- Network request monitoring
- User experience analytics

## Migration

### Version Compatibility

The package follows semantic versioning:

- **Major versions**: Breaking changes requiring migration
- **Minor versions**: New features with backward compatibility
- **Patch versions**: Bug fixes and performance improvements

### Migration Guides

Comprehensive migration guides are provided for each major version update, including:

- Step-by-step migration procedures
- Data transformation scripts
- Configuration updates
- API changes and deprecations

## Repository

This project is hosted at: [https://github.com/imacooldeveloper/DigitizingVivariumsFoundation](https://github.com/imacooldeveloper/DigitizingVivariumsFoundation)

## Contributing

Contributions are welcome! Please fork the repository, create a feature branch, and submit a pull request. For major changes, open an issue first to discuss what you would like to change.

## Documentation

### API Reference

Complete API documentation is available at [docs.digitizingvivariums.org](https://docs.digitizingvivariums.org)

### Guides

- [Getting Started Guide](Documentation/Guides/GettingStarted.md)
- [Configuration Guide](Documentation/Guides/Configuration.md)
- [Security Guide](Documentation/Guides/Security.md)
- [Performance Guide](Documentation/Guides/Performance.md)
- [Migration Guide](Documentation/Guides/Migration.md)

### Examples

- [Basic Facility Management](Documentation/Examples/BasicFacilityManagement.md)
- [Advanced Configuration](Documentation/Examples/AdvancedConfiguration.md)
- [Custom UI Components](Documentation/Examples/CustomUIComponents.md)
- [Integration with Existing Apps](Documentation/Examples/Integration.md)

## Support

### Getting Help

- **Documentation**: [docs.digitizingvivariums.org](https://docs.digitizingvivariums.org)
- **Issues**: [GitHub Issues](https://github.com/your-org/DigitizingVivariumsFoundation/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-org/DigitizingVivariumsFoundation/discussions)
- **Email**: support@digitizingvivariums.org

### Community

- **Slack**: [Join our Slack workspace](https://digitizingvivariums.slack.com)
- **Twitter**: [@DigitizingViv](https://twitter.com/DigitizingViv)
- **Blog**: [blog.digitizingvivariums.org](https://blog.digitizingvivariums.org)

## License

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Firebase team for the excellent iOS SDK
- Apple for SwiftUI and the Swift ecosystem
- The open source community for inspiration and tools
- All contributors and users of this package

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a complete list of changes and version history.

---

**DigitizingVivariumsFoundation** - Empowering the future of vivarium management through digital innovation. 