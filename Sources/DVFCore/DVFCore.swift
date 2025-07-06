// The Swift Programming Language
// https://docs.swift.org/swift-book

/// DVFCore - Foundation data models, protocols, and configuration systems
/// for the DigitizingVivariumsFoundation package.
///
/// This module provides the core building blocks for vivarium digitization
/// including data models, configuration systems, and foundational protocols.

// Re-export all public APIs from core submodules
@_exported import Foundation
@_exported import Collections

// Core data models
@_exported import struct DVFCore.DVFFacility
@_exported import struct DVFCore.DVFBuilding
@_exported import struct DVFCore.DVFLocation
@_exported import struct DVFCore.DVFRoom
@_exported import struct DVFCore.DVFEquipment
@_exported import struct DVFCore.DVFAnimal
@_exported import struct DVFCore.DVFUser
@_exported import struct DVFCore.DVFRole

// Core protocols
@_exported import protocol DVFCore.DVFIdentifiable
@_exported import protocol DVFCore.DVFTimestamped
@_exported import protocol DVFCore.DVFFacilityScoped
@_exported import protocol DVFCore.DVFValidatable
@_exported import protocol DVFCore.DVFConfigurable

// Core services
@_exported import class DVFCore.DVFCoreService
@_exported import class DVFCore.DVFFacilityManager
@_exported import class DVFCore.DVFConfigurationManager

// Core errors
@_exported import enum DVFCore.DVFCoreError 