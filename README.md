# Cross Platform Swift 6 Cyclic Redundancy Check (CRC) Library

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![CI Status](https://github.com/apache-edge/cyclic-redundancy-check/actions/workflows/swift.yml/badge.svg)](https://github.com/apache-edge/cyclic-redundancy-check/actions/workflows/swift.yml)
[![macOS](https://img.shields.io/badge/macOS-supported-success)](https://github.com/apache-edge/cyclic-redundancy-check)
[![iOS](https://img.shields.io/badge/iOS-supported-success)](https://github.com/apache-edge/cyclic-redundancy-check)
[![Linux](https://img.shields.io/badge/Linux-supported-success)](https://github.com/apache-edge/cyclic-redundancy-check)
[![Windows](https://img.shields.io/badge/Windows-supported-success)](https://github.com/apache-edge/cyclic-redundancy-check)
[![Android](https://img.shields.io/badge/Android-supported-success)](https://github.com/apache-edge/cyclic-redundancy-check)

# Features

- Support for iOS, tvOS, watchOS, macOS, Linux, Windows and Android.
- Support for CRC-8, CRC-16, CRC-32, CRC-64 with configurable parameters and flexible inputs.
- Flexible input handling: `String`, `[UInt8]` (byte arrays), `Data`, and streams for large data sets.
- Incremental CRC calculation for streaming or chunked data.
- Custom CRC definitions and verification.
- Comprehensive testing suite for unit, edge case, performance, and cross-platform compatibility.

# Installation

Add this package to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/apache-edge/cyclic-redundancy-check.git", from: "0.0.2")
]
```

# Usage

### Basic Usage

```swift
import CyclicRedundancyCheck

// One-shot CRC-32 calculation
let data = "123456789".data(using: .utf8)!
let crc32 = CyclicRedundancyCheck.crc32(data: data)
print("CRC-32: \(String(format: "0x%08X", crc32))") // Should output: 0xCBF43926

// Using a predefined standard
let crc16 = CyclicRedundancyCheck.crc16(string: "Hello, world!")
print("CRC-16: \(String(format: "0x%04X", crc16))")

// Incremental calculation
var calculator = CyclicRedundancyCheck(algorithm: .crc32)
calculator.reset()
calculator.update(with: "Hello, ".data(using: .utf8)!)
calculator.update(with: "world!".data(using: .utf8)!)
let result = calculator.checksum
```

### Custom CRC Configuration

```swift
// Creating a custom CRC algorithm
let customConfig = CyclicRedundancyCheckConfiguration(
    width: 16,
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
let data = "123456789".data(using: .utf8)!
let expectedCRC: UInt32 = 0xCBF43926
var calculator = CyclicRedundancyCheck(algorithm: .crc32)
let isValid = calculator.verify(data: data, against: UInt64(expectedCRC))
print("CRC verification: \(isValid ? "Valid" : "Invalid")")
```

For more details on how to use the library, see the tests in the `Tests` directory.

# License

Apache License 2.0