# Cross Platform Swift 6 Cyclic Redundancy Check (CRC) Library

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![CI Status](https://github.com/edgeengineer/cyclic-redundancy-check/actions/workflows/swift.yml/badge.svg)](https://github.com/edgeengineer/cyclic-redundancy-check/actions/workflows/swift.yml)
[![macOS](https://img.shields.io/badge/macOS-supported-success)](https://github.com/edgeengineer/cyclic-redundancy-check)
[![iOS](https://img.shields.io/badge/iOS-supported-success)](https://github.com/edgeengineer/cyclic-redundancy-check)
[![Linux](https://img.shields.io/badge/Linux-supported-success)](https://github.com/edgeengineer/cyclic-redundancy-check)
[![Windows](https://img.shields.io/badge/Windows-supported-success)](https://github.com/edgeengineer/cyclic-redundancy-check)
[![Android](https://img.shields.io/badge/Android-supported-success)](https://github.com/edgeengineer/cyclic-redundancy-check)

# Features

- Support for iOS, tvOS, watchOS, macOS, Linux, Windows and Android.
- Support for CRC-8, CRC-16, CRC-32, CRC-32C (Castagnoli), CRC-64 with configurable parameters and flexible inputs.
- Flexible input handling: `String`, `[UInt8]` (byte arrays), `Data`, and streams for large data sets.
- Incremental CRC calculation for streaming or chunked data.
- Custom CRC definitions and verification.
- Comprehensive testing suite for unit, edge case, performance, and cross-platform compatibility.

# Installation

Add this package to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/edgeengineer/cyclic-redundancy-check.git", from: "0.0.4")
]
```

# Usage

## Supported CRC Algorithms

The library includes pre-configured implementations of common CRC algorithms:

- **CRC-8**: Standard CRC-8, CRC-8-CDMA2000, CRC-8-WCDMA
- **CRC-16**: CRC-16-IBM, CRC-16-CCITT, CRC-16-XMODEM, CRC-16-MODBUS
- **CRC-32**: CRC-32 (Ethernet), CRC-32-BZIP2, CRC-32-MPEG2, CRC-32-POSIX, CRC-32C (Castagnoli)
- **CRC-64**: CRC-64-ISO, CRC-64-ECMA

### Basic Usage

```swift
import CyclicRedundancyCheck

// One-shot CRC-32 calculation
let crc32 = CyclicRedundancyCheck.crc32(string: "123456789")
print("CRC-32: \(String(format: "0x%08X", crc32))") // Should output: 0xCBF43926

// Using a predefined standard
let crc16 = CyclicRedundancyCheck.crc16(string: "Hello, world!")
print("CRC-16: \(String(format: "0x%04X", crc16))")

// CRC-32C (Castagnoli) - commonly used for data integrity
let crc32c = CyclicRedundancyCheck.crc32c(string: "123456789")
print("CRC-32C: \(String(format: "0x%08X", crc32c))") // Should output: 0xE3069283

// Incremental calculation
var calculator = CyclicRedundancyCheck(algorithm: .crc32)
calculator.update(with: "Hello, ")
calculator.update(with: "world!")
let result = calculator.checksum
```

### Custom CRC Configuration

```swift
// Creating a custom CRC algorithm
let customConfig = CyclicRedundancyCheckConfiguration<UInt16>(
    polynomial: 0x8005,
    initialValue: 0xFFFF,
    finalXORValue: 0x0000,
    reflectInput: true,
    reflectOutput: true
)

var customCRC = CyclicRedundancyCheck(configuration: customConfig)
let result = customCRC.compute(string: "Test data")
```

### Verification

```swift
let expectedCRC: UInt32 = 0xCBF43926
var calculator = CyclicRedundancyCheck(algorithm: .crc32)
let isValid = calculator.verify(string: "123456789", against: expectedCRC)
print("CRC verification: \(isValid ? "Valid" : "Invalid")")
```

For more details on how to use the library, see the tests in the `Tests` directory.

# License

Apache License 2.0
