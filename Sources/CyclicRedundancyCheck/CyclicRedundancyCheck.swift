// CyclicRedundancyCheck
// A comprehensive Swift library for cyclic redundancy check calculation across multiple platforms

/// Represents a cyclic redundancy check algorithm configuration
public struct CyclicRedundancyCheckConfiguration<Polynomial: FixedWidthInteger & Sendable>: Sendable {
    /// Polynomial used for CRC calculation
    public let polynomial: Polynomial
    
    /// Initial value for the CRC calculation
    public let initialValue: Polynomial
    
    /// Value to XOR with the final CRC result
    public let finalXORValue: Polynomial
    
    /// Whether input bytes should be reflected (bit order reversed)
    public let reflectInput: Bool
    
    /// Whether the final CRC value should be reflected
    public let reflectOutput: Bool
    
    public init(
        polynomial: Polynomial,
        initialValue: Polynomial,
        finalXORValue: Polynomial,
        reflectInput: Bool,
        reflectOutput: Bool
    ) {
        self.polynomial = polynomial
        self.initialValue = initialValue
        self.finalXORValue = finalXORValue
        self.reflectInput = reflectInput
        self.reflectOutput = reflectOutput
    }
}

/// Standard cyclic redundancy check algorithm configurations
public struct StandardCyclicRedundancyCheckAlgorithm<Polynomial: FixedWidthInteger & Sendable>: Sendable {
    public let configuration: CyclicRedundancyCheckConfiguration<Polynomial>
}

public extension StandardCyclicRedundancyCheckAlgorithm<UInt8> {
    // CRC-8 variants
    static let crc8 = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x07,
            initialValue: 0x00,
            finalXORValue: 0x00,
            reflectInput: false,
            reflectOutput: false
        )
    )
    static let crc8CDMA2000 = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x9B,
            initialValue: 0xFF,
            finalXORValue: 0x00,
            reflectInput: false,
            reflectOutput: false
        )
    )
    static let crc8WCDMA = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x9B,
            initialValue: 0x00,
            finalXORValue: 0x00,
            reflectInput: true,
            reflectOutput: true
        )
    )
}

// CRC-16 variants
public extension StandardCyclicRedundancyCheckAlgorithm<UInt16> {
    static let crc16 = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x8005,
            initialValue: 0x0000,
            finalXORValue: 0x0000,
            reflectInput: true,
            reflectOutput: true
        )
    )
    static let crc16CCITT = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x1021,
            initialValue: 0xFFFF,
            finalXORValue: 0x0000,
            reflectInput: false,
            reflectOutput: false
        )
    )
    static let crc16XMODEM = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x1021,
            initialValue: 0x0000,
            finalXORValue: 0x0000,
            reflectInput: false,
            reflectOutput: false
        )
    )
    static let crc16IBM = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x8005,
            initialValue: 0x0000,
            finalXORValue: 0x0000,
            reflectInput: true,
            reflectOutput: true
        )
    )
    static let crc16MODBUS = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x8005,
            initialValue: 0xFFFF,
            finalXORValue: 0x0000,
            reflectInput: true,
            reflectOutput: true
        )
    )
}

// CRC-32 variants
public extension StandardCyclicRedundancyCheckAlgorithm<UInt32> {
    static let crc32 = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x04C11DB7,
            initialValue: 0xFFFFFFFF,
            finalXORValue: 0xFFFFFFFF,
            reflectInput: true,
            reflectOutput: true
        )
    )
    static let crc32BZIP2 = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x04C11DB7,
            initialValue: 0xFFFFFFFF,
            finalXORValue: 0xFFFFFFFF,
            reflectInput: false,
            reflectOutput: false
        )
    )
    static let crc32MPEG2 = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x04C11DB7,
            initialValue: 0xFFFFFFFF,
            finalXORValue: 0x00000000,
            reflectInput: false,
            reflectOutput: false
        )
    )
    static let crc32POSIX = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x04C11DB7,
            initialValue: 0x00000000,
            finalXORValue: 0xFFFFFFFF,
            reflectInput: false,
            reflectOutput: false
        )
    )
    static let crc32C = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x1EDC6F41,
            initialValue: 0xFFFFFFFF,
            finalXORValue: 0xFFFFFFFF,
            reflectInput: true,
            reflectOutput: true
        )
    )
}

public extension StandardCyclicRedundancyCheckAlgorithm<UInt64> {
    // CRC-64 variants
    static let crc64ISO = StandardCyclicRedundancyCheckAlgorithm(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x000000000000001B,
            initialValue: 0xFFFFFFFFFFFFFFFF,
            finalXORValue: 0xFFFFFFFFFFFFFFFF,
            reflectInput: true,
            reflectOutput: true
        )
    )
    static let crc64ECMA = StandardCyclicRedundancyCheckAlgorithm<UInt64>(
        configuration: CyclicRedundancyCheckConfiguration(
            polynomial: 0x42F0E1EBA9EA3693,
            initialValue: 0x0000000000000000,
            finalXORValue: 0x0000000000000000,
            reflectInput: false,
            reflectOutput: false
        )
    )
}

/// Main cyclic redundancy check calculator struct
public struct CyclicRedundancyCheck<Polynomial: FixedWidthInteger & Sendable>: Sendable {
    @usableFromInline
    internal let configuration: CyclicRedundancyCheckConfiguration<Polynomial>
    // TODO: Replace with InlineArray<256> down the line 
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0453-vector.md
    @usableFromInline
    internal let lookupTable: [Polynomial]
    @usableFromInline
    internal var currentValue: Polynomial
    
    /// Initialize a cyclic redundancy check calculator with a standard algorithm
    public init(algorithm: StandardCyclicRedundancyCheckAlgorithm<Polynomial>) {
        self.configuration = algorithm.configuration
        self.lookupTable = CyclicRedundancyCheck.generateLookupTable(configuration: configuration)
        self.currentValue = configuration.initialValue
    }
    
    /// Initialize a cyclic redundancy check calculator with a custom configuration
    public init(configuration: CyclicRedundancyCheckConfiguration<Polynomial>) {
        self.configuration = configuration
        self.lookupTable = CyclicRedundancyCheck.generateLookupTable(configuration: configuration)
        self.currentValue = configuration.initialValue
    }
    
    /// Resets the cyclic redundancy check calculator to initial state
    public mutating func reset() {
        currentValue = configuration.initialValue
    }

    /// Update the cyclic redundancy check with new data (incremental calculation)
    @inlinable
    @_specialize(where Polynomial == UInt8, Bytes == UnsafeRawBufferPointer)
    @_specialize(where Polynomial == UInt16, Bytes == UnsafeRawBufferPointer)
    @_specialize(where Polynomial == UInt32, Bytes == UnsafeRawBufferPointer)
    @_specialize(where Polynomial == UInt64, Bytes == UnsafeRawBufferPointer)
    public mutating func update<Bytes: Sequence>(with bytes: Bytes) where Bytes.Element == UInt8 {
        if bytes.withContiguousStorageIfAvailable({ buffer in
            _update(with: buffer)
            return true
        }) != true {
            update_slowPath(with: bytes)
        }
    }

    @inline(never)
    @usableFromInline
    internal mutating func update_slowPath(with buffer: some Sequence<UInt8>) {
        _update(with: buffer)
    }

    /// Update the cyclic redundancy check with new data (incremental calculation)
    @inlinable
    @_specialize(where Polynomial == UInt8, Bytes == UnsafeRawBufferPointer)
    @_specialize(where Polynomial == UInt16, Bytes == UnsafeRawBufferPointer)
    @_specialize(where Polynomial == UInt32, Bytes == UnsafeRawBufferPointer)
    @_specialize(where Polynomial == UInt64, Bytes == UnsafeRawBufferPointer)
    internal mutating func _update<Bytes: Sequence>(with buffer: Bytes) where Bytes.Element == UInt8 {
        // We branch before the loop to avoid unnecessary reflection
        // logic in the hot path
        if Polynomial.self == UInt8.self {
            if configuration.reflectInput {
                for byte in buffer {
                    let index = UInt8(truncatingIfNeeded: currentValue) ^ CyclicRedundancyCheck<UInt8>.reflect(value: byte)
                    currentValue = lookupTable[Int(index)]
                }
            } else {
                for byte in buffer {
                    let index = UInt8(truncatingIfNeeded: currentValue) ^ byte
                    currentValue = lookupTable[Int(index)]
                }
            }
        } else if Polynomial.self == UInt16.self, configuration.reflectInput {
            for byte in buffer {
                let index = UInt8(truncatingIfNeeded: currentValue) ^ CyclicRedundancyCheck<UInt8>.reflect(value: byte)
                currentValue = (currentValue &>> 8) ^ lookupTable[Int(index)]
            }
        } else if configuration.reflectInput {
            for byte in buffer {
                let index = UInt8(truncatingIfNeeded: currentValue) ^ byte
                currentValue = (currentValue &>> 8) ^ lookupTable[Int(index)]
            }
        } else {
            let shiftAmount = Polynomial.bitWidth &- 8
            for byte in buffer {
                let index = UInt8(truncatingIfNeeded: currentValue &>> shiftAmount) ^ byte
                currentValue = (currentValue &<< 8) ^ lookupTable[Int(index)]
            }
        }
    }

    /// Update the cyclic redundancy check with a single byte
    @inline(__always)
    public mutating func update(with string: String) {
        update(with: string.utf8)
    }

    /// Calculate the final cyclic redundancy check value
    public var checksum: Polynomial {
        let mask = Self.bitMask
        var result = currentValue
        
        if configuration.reflectOutput != configuration.reflectInput {
            result = CyclicRedundancyCheck.reflect(value: result)
        }
        
        // Apply final XOR and mask to width bits
        return (result ^ configuration.finalXORValue) & mask
    }
    
    /// Compute a cyclic redundancy check for byte array in a single call
    @inlinable
    @inline(__always)
    @_specialize(where Polynomial == UInt8, Bytes == UnsafeRawBufferPointer)
    @_specialize(where Polynomial == UInt16, Bytes == UnsafeRawBufferPointer)
    @_specialize(where Polynomial == UInt32, Bytes == UnsafeRawBufferPointer)
    @_specialize(where Polynomial == UInt64, Bytes == UnsafeRawBufferPointer)
    public mutating func compute<Bytes: Sequence>(bytes: Bytes) -> Polynomial where Bytes.Element == UInt8 {
        reset()
        update(with: bytes)
        return checksum
    }

    /// Compute a cyclic redundancy check for byte array in a single call
    @inlinable
    @inline(__always)
    public mutating func compute(bytes: UnsafeRawBufferPointer) -> Polynomial {
        reset()
        update(with: bytes)
        return checksum
    }

    /// Compute a cyclic redundancy check for string in a single call
    @inlinable
    public mutating func compute(string: String) -> Polynomial {
        return compute(bytes: string.utf8)
    }
    
    /// Verify if a given checksum matches the computed cyclic redundancy check for input data
    @inlinable
    @inline(__always)
    public mutating func verify(bytes: some Sequence<UInt8>, against expectedChecksum: Polynomial) -> Bool {
        compute(bytes: bytes) == expectedChecksum
    }
    
    /// Verify if a given checksum matches the computed cyclic redundancy check for input string
    @inlinable
    public mutating func verify(string: String, against expectedChecksum: Polynomial) -> Bool {
        compute(bytes: string.utf8) == expectedChecksum
    }
    
    // MARK: - Helper Methods
    
    /// Generate lookup table for faster cyclic redundancy check computation
    @usableFromInline
    internal static func generateLookupTable(configuration: CyclicRedundancyCheckConfiguration<Polynomial>) -> [Polynomial] {
        var table = [Polynomial](repeating: Polynomial(0), count: 256)
        let width = Polynomial.bitWidth
        let polynomial = configuration.polynomial
        let mask = Self.bitMask
        
        for i: UInt8 in .min ... .max {
            var crc = 0 as Polynomial
            let data: Polynomial
            
            if configuration.reflectInput {
                data = Polynomial(CyclicRedundancyCheck<UInt8>.reflect(value: i))
            } else {
                data = Polynomial(i)
            }
            
            // CRC algorithm differs based on reflection settings
            if configuration.reflectInput {
                crc = data
                for _ in 0..<8 {
                    if (crc & 1) != 0 {
                        crc = (crc &>> 1) ^ polynomial
                    } else {
                        crc &>>= 1
                    }
                }
            } else {
                crc = data &<< (width &- 8)
                
                for _ in 0..<8 {
                    if (crc & (1 &<< (width &- 1))) != 0 {
                        crc = (crc &<< 1) ^ polynomial
                    } else {
                        crc &<<= 1
                    }
                }
            }
            
            table[Int(i)] = crc & mask
        }
        
        return table
    }
    
    /// Create a bit mask for the specified width
    @usableFromInline
    internal static var bitMask: Polynomial {
        return Polynomial.max
    }
    
    /// Reflect a value of specified width (reverse bit order)
    @usableFromInline
    @inline(__always)
    internal static func reflect(value: Polynomial) -> Polynomial {
        var input = value
        var output: Polynomial = 0
        
        for _ in 0..<Polynomial.bitWidth {
            output = (output &<< 1) | (input & 1)
            input &>>= 1
        }
        
        return output
    }
}

// MARK: - Convenience Methods

public extension CyclicRedundancyCheck<UInt8> {
    /// Compute cyclic redundancy check (CRC-8) for data
    @inlinable
    @inline(__always)
    static func crc8(bytes: some Sequence<UInt8>) -> UInt8 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc8)
        return UInt8(truncatingIfNeeded: cyclicRedundancyCheck.compute(bytes: bytes))
    }
    
    /// Compute cyclic redundancy check (CRC-8) for string
    @inlinable
    static func crc8(string: String) -> UInt8 {
        return crc8(bytes: string.utf8)
    }
}

public extension CyclicRedundancyCheck<UInt16> {
    /// Compute cyclic redundancy check (CRC-16) for data
    @inlinable
    @inline(__always)
    static func crc16(bytes: some Sequence<UInt8>) -> UInt16 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc16)
        return UInt16(truncatingIfNeeded: cyclicRedundancyCheck.compute(bytes: bytes))
    }
    
    /// Compute cyclic redundancy check (CRC-16) for string
    @inlinable
    static func crc16(string: String) -> UInt16 {
        return crc16(bytes: string.utf8)
    }
}

public extension CyclicRedundancyCheck<UInt32> {
    /// Compute cyclic redundancy check (CRC-32) for data
    @inlinable
    @inline(__always)
    static func crc32(bytes: some Sequence<UInt8>) -> UInt32 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc32)
        return UInt32(truncatingIfNeeded: cyclicRedundancyCheck.compute(bytes: bytes))
    }
    
    /// Compute cyclic redundancy check (CRC-32) for string
    @inlinable
    static func crc32(string: String) -> UInt32 {
        return crc32(bytes: string.utf8)
    }
    
    /// Compute cyclic redundancy check (CRC-32C Castagnoli) for data
    @inlinable
    @inline(__always)
    static func crc32c(bytes: some Sequence<UInt8>) -> UInt32 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc32C)
        return UInt32(truncatingIfNeeded: cyclicRedundancyCheck.compute(bytes: bytes))
    }
    
    /// Compute cyclic redundancy check (CRC-32C Castagnoli) for string
    @inlinable
    static func crc32c(string: String) -> UInt32 {
        return crc32c(bytes: string.utf8)
    }
}

public extension CyclicRedundancyCheck<UInt64> {
    /// Compute cyclic redundancy check (CRC-64) for data
    @inlinable
    @inline(__always)
    static func crc64(bytes: some Sequence<UInt8>) -> UInt64 {
        var cyclicRedundancyCheck = CyclicRedundancyCheck(algorithm: .crc64ECMA)
        return cyclicRedundancyCheck.compute(bytes: bytes)
    }
    
    /// Compute cyclic redundancy check (CRC-64) for string
    @inlinable
    static func crc64(string: String) -> UInt64 {
        return crc64(bytes: string.utf8)
    }
}
