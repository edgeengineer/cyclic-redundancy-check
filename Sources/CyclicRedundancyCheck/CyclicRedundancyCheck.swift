// CyclicRedundancyCheck
// A comprehensive Swift library for cyclic redundancy check calculation across multiple platforms

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

/// Represents a cyclic redundancy check algorithm configuration
public struct CyclicRedundancyCheckConfiguration {
    /// Width of the CRC polynomial in bits
    public let width: Int
    
    /// Polynomial used for CRC calculation
    public let polynomial: UInt64
    
    /// Initial value for the CRC calculation
    public let initialValue: UInt64
    
    /// Value to XOR with the final CRC result
    public let finalXORValue: UInt64
    
    /// Whether input bytes should be reflected (bit order reversed)
    public let reflectInput: Bool
    
    /// Whether the final CRC value should be reflected
    public let reflectOutput: Bool
    
    public init(
        width: Int,
        polynomial: UInt64,
        initialValue: UInt64,
        finalXORValue: UInt64,
        reflectInput: Bool,
        reflectOutput: Bool
    ) {
        self.width = width
        self.polynomial = polynomial
        self.initialValue = initialValue
        self.finalXORValue = finalXORValue
        self.reflectInput = reflectInput
        self.reflectOutput = reflectOutput
    }
}

/// Standard cyclic redundancy check algorithm configurations
public enum StandardCyclicRedundancyCheckAlgorithm {
    // CRC-8 variants
    case crc8
    case crc8CDMA2000
    case crc8WCDMA
    
    // CRC-16 variants
    case crc16
    case crc16CCITT
    case crc16XMODEM
    case crc16IBM
    case crc16MODBUS
    
    // CRC-32 variants
    case crc32
    case crc32BZIP2
    case crc32MPEG2
    case crc32POSIX
    
    // CRC-64 variants
    case crc64ISO
    case crc64ECMA
    
    public var configuration: CyclicRedundancyCheckConfiguration {
        switch self {
        // CRC-8 variants
        case .crc8:
            return CyclicRedundancyCheckConfiguration(
                width: 8,
                polynomial: 0x07,
                initialValue: 0x00,
                finalXORValue: 0x00,
                reflectInput: false,
                reflectOutput: false
            )
        case .crc8CDMA2000:
            return CyclicRedundancyCheckConfiguration(
                width: 8,
                polynomial: 0x9B,
                initialValue: 0xFF,
                finalXORValue: 0x00,
                reflectInput: false,
                reflectOutput: false
            )
        case .crc8WCDMA:
            return CyclicRedundancyCheckConfiguration(
                width: 8,
                polynomial: 0x9B,
                initialValue: 0x00,
                finalXORValue: 0x00,
                reflectInput: true,
                reflectOutput: true
            )
            
        // CRC-16 variants
        case .crc16:
            return CyclicRedundancyCheckConfiguration(
                width: 16,
                polynomial: 0x8005,
                initialValue: 0x0000,
                finalXORValue: 0x0000,
                reflectInput: true,
                reflectOutput: true
            )
        case .crc16CCITT:
            return CyclicRedundancyCheckConfiguration(
                width: 16,
                polynomial: 0x1021,
                initialValue: 0xFFFF,
                finalXORValue: 0x0000,
                reflectInput: false,
                reflectOutput: false
            )
        case .crc16XMODEM:
            return CyclicRedundancyCheckConfiguration(
                width: 16,
                polynomial: 0x1021,
                initialValue: 0x0000,
                finalXORValue: 0x0000,
                reflectInput: false,
                reflectOutput: false
            )
        case .crc16IBM:
            return CyclicRedundancyCheckConfiguration(
                width: 16,
                polynomial: 0x8005,
                initialValue: 0x0000,
                finalXORValue: 0x0000,
                reflectInput: true,
                reflectOutput: true
            )
        case .crc16MODBUS:
            return CyclicRedundancyCheckConfiguration(
                width: 16,
                polynomial: 0x8005,
                initialValue: 0xFFFF,
                finalXORValue: 0x0000,
                reflectInput: true,
                reflectOutput: true
            )
            
        // CRC-32 variants
        case .crc32:
            return CyclicRedundancyCheckConfiguration(
                width: 32,
                polynomial: 0x04C11DB7,
                initialValue: 0xFFFFFFFF,
                finalXORValue: 0xFFFFFFFF,
                reflectInput: true,
                reflectOutput: true
            )
        case .crc32BZIP2:
            return CyclicRedundancyCheckConfiguration(
                width: 32,
                polynomial: 0x04C11DB7,
                initialValue: 0xFFFFFFFF,
                finalXORValue: 0xFFFFFFFF,
                reflectInput: false,
                reflectOutput: false
            )
        case .crc32MPEG2:
            return CyclicRedundancyCheckConfiguration(
                width: 32,
                polynomial: 0x04C11DB7,
                initialValue: 0xFFFFFFFF,
                finalXORValue: 0x00000000,
                reflectInput: false,
                reflectOutput: false
            )
        case .crc32POSIX:
            return CyclicRedundancyCheckConfiguration(
                width: 32,
                polynomial: 0x04C11DB7,
                initialValue: 0x00000000,
                finalXORValue: 0xFFFFFFFF,
                reflectInput: false,
                reflectOutput: false
            )
            
        // CRC-64 variants
        case .crc64ISO:
            return CyclicRedundancyCheckConfiguration(
                width: 64,
                polynomial: 0x000000000000001B,
                initialValue: 0xFFFFFFFFFFFFFFFF,
                finalXORValue: 0xFFFFFFFFFFFFFFFF,
                reflectInput: true,
                reflectOutput: true
            )
        case .crc64ECMA:
            return CyclicRedundancyCheckConfiguration(
                width: 64,
                polynomial: 0x42F0E1EBA9EA3693,
                initialValue: 0x0000000000000000,
                finalXORValue: 0x0000000000000000,
                reflectInput: false,
                reflectOutput: false
            )
        }
    }
}

/// Main cyclic redundancy check calculator struct
public struct CyclicRedundancyCheck {
    private let configuration: CyclicRedundancyCheckConfiguration
    private let lookupTable: [UInt64]
    private var currentValue: UInt64
    
    /// Initialize a cyclic redundancy check calculator with a standard algorithm
    public init(algorithm: StandardCyclicRedundancyCheckAlgorithm) {
        self.configuration = algorithm.configuration
        self.lookupTable = CyclicRedundancyCheck.generateLookupTable(configuration: configuration)
        self.currentValue = configuration.initialValue
    }
    
    /// Initialize a cyclic redundancy check calculator with a custom configuration
    public init(configuration: CyclicRedundancyCheckConfiguration) {
        self.configuration = configuration
        self.lookupTable = CyclicRedundancyCheck.generateLookupTable(configuration: configuration)
        self.currentValue = configuration.initialValue
    }
    
    /// Resets the cyclic redundancy check calculator to initial state
    public mutating func reset() {
        currentValue = configuration.initialValue
    }
    
    /// Update the cyclic redundancy check with new data (incremental calculation)
    public mutating func update(with data: Data) {
        for byte in data {
            update(with: byte)
        }
    }
    
    /// Update the cyclic redundancy check with a byte array
    public mutating func update(with bytes: [UInt8]) {
        for byte in bytes {
            update(with: byte)
        }
    }
    
    /// Update the cyclic redundancy check with a string (using UTF-8 encoding)
    public mutating func update(with string: String) {
        guard let data = string.data(using: .utf8) else { return }
        update(with: data)
    }
    
    /// Update the cyclic redundancy check with a single byte
    private mutating func update(with byte: UInt8) {
        let width = configuration.width
        
        if width <= 8 {
            // For CRC-8
            if configuration.reflectInput {
                let index = Int(UInt8(truncatingIfNeeded: currentValue) ^ CyclicRedundancyCheck.reflect(byte: byte))
                currentValue = lookupTable[index]
            } else {
                let index = Int(UInt8(truncatingIfNeeded: currentValue) ^ byte)
                currentValue = lookupTable[index]
            }
        } else if width <= 16 {
            // For CRC-16
            if configuration.reflectInput {
                let index = Int(UInt8(truncatingIfNeeded: currentValue) ^ CyclicRedundancyCheck.reflect(byte: byte))
                currentValue = (currentValue >> 8) ^ lookupTable[index]
            } else {
                let index = Int(UInt8(truncatingIfNeeded: currentValue >> 8) ^ byte)
                currentValue = ((currentValue << 8) & 0xFFFF) ^ lookupTable[index]
            }
        } else if width <= 32 {
            // For CRC-32
            if configuration.reflectInput {
                let index = Int(UInt8(truncatingIfNeeded: currentValue) ^ byte)
                currentValue = (currentValue >> 8) ^ lookupTable[index]
            } else {
                let index = Int(UInt8(truncatingIfNeeded: currentValue >> 24) ^ byte)
                currentValue = ((currentValue << 8) & 0xFFFFFFFF) ^ lookupTable[index]
            }
        } else {
            // For CRC-64
            if configuration.reflectInput {
                let index = Int(UInt8(truncatingIfNeeded: currentValue) ^ byte)
                currentValue = (currentValue >> 8) ^ lookupTable[index]
            } else {
                let index = Int(UInt8(truncatingIfNeeded: currentValue >> 56) ^ byte)
                currentValue = ((currentValue << 8)) ^ lookupTable[index]
            }
        }
    }
    
    /// Calculate the final cyclic redundancy check value
    public var checksum: UInt64 {
        let width = configuration.width
        let mask = CyclicRedundancyCheck.bitMask(width: width)
        
        var result = currentValue
        
        if configuration.reflectOutput != configuration.reflectInput {
            if width <= 8 {
                result = UInt64(CyclicRedundancyCheck.reflect(byte: UInt8(truncatingIfNeeded: result)))
            } else if width <= 16 {
                result = UInt64(CyclicRedundancyCheck.reflect(value: result, width: 16))
            } else if width <= 32 {
                result = UInt64(CyclicRedundancyCheck.reflect(value: result, width: 32))
            } else {
                result = CyclicRedundancyCheck.reflect(value: result, width: 64)
            }
        }
        
        // Apply final XOR and mask to width bits
        return (result ^ configuration.finalXORValue) & mask
    }
    
    /// Compute a cyclic redundancy check for data in a single call
    public mutating func compute(data: Data) -> UInt64 {
        reset()
        update(with: data)
        return checksum
    }
    
    /// Compute a cyclic redundancy check for byte array in a single call
    public mutating func compute(bytes: [UInt8]) -> UInt64 {
        reset()
        update(with: bytes)
        return checksum
    }
    
    /// Compute a cyclic redundancy check for string in a single call
    public mutating func compute(string: String) -> UInt64 {
        reset()
        update(with: string)
        return checksum
    }
    
    /// Verify if a given checksum matches the computed cyclic redundancy check for input data
    public mutating func verify(data: Data, against expectedChecksum: UInt64) -> Bool {
        compute(data: data) == expectedChecksum
    }
    
    /// Verify if a given checksum matches the computed cyclic redundancy check for input byte array
    public mutating func verify(bytes: [UInt8], against expectedChecksum: UInt64) -> Bool {
        compute(bytes: bytes) == expectedChecksum
    }
    
    /// Verify if a given checksum matches the computed cyclic redundancy check for input string
    public mutating func verify(string: String, against expectedChecksum: UInt64) -> Bool {
        compute(string: string) == expectedChecksum
    }
    
    // MARK: - Helper Methods
    
    /// Generate lookup table for faster cyclic redundancy check computation
    private static func generateLookupTable(configuration: CyclicRedundancyCheckConfiguration) -> [UInt64] {
        var table = [UInt64](repeating: 0, count: 256)
        let width = configuration.width
        let polynomial = configuration.polynomial
        let mask = bitMask(width: width)
        
        for i in 0..<256 {
            var crc: UInt64 = 0
            var data = UInt64(i)
            
            if configuration.reflectInput {
                data = UInt64(reflect(byte: UInt8(i)))
            }
            
            // CRC algorithm differs based on reflection settings
            if configuration.reflectInput {
                crc = data
                for _ in 0..<8 {
                    if (crc & 1) != 0 {
                        crc = (crc >> 1) ^ polynomial
                    } else {
                        crc >>= 1
                    }
                }
            } else {
                crc = data << (width - 8)
                
                for _ in 0..<8 {
                    if (crc & (1 << (width - 1))) != 0 {
                        crc = (crc << 1) ^ polynomial
                    } else {
                        crc <<= 1
                    }
                }
            }
            
            table[i] = crc & mask
        }
        
        return table
    }
    
    /// Create a bit mask for the specified width
    private static func bitMask(width: Int) -> UInt64 {
        if width >= 64 {
            return UInt64.max
        }
        return (1 << width) - 1
    }
    
    /// Reflect a byte (reverse bit order)
    private static func reflect(byte: UInt8) -> UInt8 {
        var input = byte
        var output: UInt8 = 0
        
        for _ in 0..<8 {
            output = (output << 1) | (input & 1)
            input >>= 1
        }
        
        return output
    }
    
    /// Reflect a value of specified width (reverse bit order)
    private static func reflect(value: UInt64, width: Int) -> UInt64 {
        var input = value
        var output: UInt64 = 0
        
        for _ in 0..<width {
            output = (output << 1) | (input & 1)
            input >>= 1
        }
        
        return output
    }
}

// MARK: - Convenience Methods

public extension CyclicRedundancyCheck {
    /// Compute cyclic redundancy check (CRC-8) for data
    static func crc8(data: Data) -> UInt8 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc8)
        return UInt8(truncatingIfNeeded: cyclicRedundancyCheck.compute(data: data))
    }
    
    /// Compute cyclic redundancy check (CRC-16) for data
    static func crc16(data: Data) -> UInt16 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc16)
        return UInt16(truncatingIfNeeded: cyclicRedundancyCheck.compute(data: data))
    }
    
    /// Compute cyclic redundancy check (CRC-32) for data
    static func crc32(data: Data) -> UInt32 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc32)
        return UInt32(truncatingIfNeeded: cyclicRedundancyCheck.compute(data: data))
    }
    
    /// Compute cyclic redundancy check (CRC-64) for data
    static func crc64(data: Data) -> UInt64 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc64ECMA)
        return cyclicRedundancyCheck.compute(data: data)
    }
    
    /// Compute cyclic redundancy check (CRC-8) for string
    static func crc8(string: String) -> UInt8 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc8)
        return UInt8(truncatingIfNeeded: cyclicRedundancyCheck.compute(string: string))
    }
    
    /// Compute cyclic redundancy check (CRC-16) for string
    static func crc16(string: String) -> UInt16 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc16)
        return UInt16(truncatingIfNeeded: cyclicRedundancyCheck.compute(string: string))
    }
    
    /// Compute cyclic redundancy check (CRC-32) for string
    static func crc32(string: String) -> UInt32 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc32)
        return UInt32(truncatingIfNeeded: cyclicRedundancyCheck.compute(string: string))
    }
    
    /// Compute cyclic redundancy check (CRC-64) for string
    static func crc64(string: String) -> UInt64 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc64ECMA)
        return cyclicRedundancyCheck.compute(string: string)
    }
}