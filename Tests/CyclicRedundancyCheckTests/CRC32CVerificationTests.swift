import Testing
import Foundation
@testable import CyclicRedundancyCheck

@Suite("CRC32C Verification Tests")
struct CRC32CVerificationTests {
    @Test("CRC32C should match standard test vectors")
    func testCRC32CStandardVectors() async throws {
        // Standard test vector: "123456789" -> 0xE3069283
        let standardTestString = "123456789"
        let expectedStandardCRC: UInt32 = 0xE3069283
        
        var crc = CyclicRedundancyCheck(algorithm: .crc32C)
        let result = crc.compute(string: standardTestString)
        
        #expect(result == expectedStandardCRC, "CRC32C for '123456789' should be 0xE3069283, got 0x\(String(format: "%08X", result))")
        
        // Test with static helper method
        let staticResult = CyclicRedundancyCheck.crc32c(string: standardTestString)
        #expect(staticResult == expectedStandardCRC, "Static CRC32C for '123456789' should be 0xE3069283, got 0x\(String(format: "%08X", staticResult))")
    }
    
    @Test("CRC32C should match additional test vectors")
    func testCRC32CAdditionalVectors() async throws {
        // Test vector from the issue
        var data = Data()
        data.append(contentsOf: [0x00, 0x00, 0x00, 0x17, 0x0a, 0x0a, 0x70, 0x72, 
                                0x6f, 0x64, 0x75, 0x63, 0x65, 0x72, 0x2d, 0x31, 
                                0x10, 0x03, 0x18, 0x9e, 0xb3, 0x84, 0x94, 0x85, 
                                0x33, 0x40, 0x00, 0x4d, 0x65, 0x73, 0x73, 0x61, 
                                0x67, 0x65, 0x20, 0x33])
        
        let expectedCRC: UInt32 = 3677009909 // 0xDB2AB7F5
        
        let result = CyclicRedundancyCheck.crc32c(bytes: data)
        
        #expect(result == expectedCRC, "CRC32C for test data should be 3677009909 (0xDB2AB7F5), got \(result) (0x\(String(format: "%08X", result)))")
    }
    
    @Test("CRC32C should handle empty input correctly")
    func testCRC32CEmptyInput() async throws {
        let emptyString = ""
        let expectedCRC: UInt32 = 0x00000000
        
        let result = CyclicRedundancyCheck.crc32c(string: emptyString)
        
        #expect(result == expectedCRC, "CRC32C for empty string should be 0x00000000, got 0x\(String(format: "%08X", result))")
    }
    
    @Test("CRC32C should handle single character correctly")
    func testCRC32CSingleCharacter() async throws {
        let singleChar = "a"
        // Expected value based on standard CRC32C implementations
        // The bytes would be: 0xC1D04330 in little-endian
        let expectedCRC: UInt32 = 0xC1D04330
        
        let result = CyclicRedundancyCheck.crc32c(string: singleChar)
        
        #expect(result == expectedCRC, "CRC32C for 'a' should be 0xC1D04330, got 0x\(String(format: "%08X", result))")
    }
    
    @Test("CRC32C should handle test phrase correctly")
    func testCRC32CTestPhrase() async throws {
        let testPhrase = "The quick brown fox jumps over the lazy dog"
        // Expected value based on standard CRC32C implementations
        let expectedCRC: UInt32 = 0x22620404
        
        let result = CyclicRedundancyCheck.crc32c(string: testPhrase)
        
        #expect(result == expectedCRC, "CRC32C for test phrase should be 0x22620404, got 0x\(String(format: "%08X", result))")
    }
    
    @Test("CRC32C incremental calculation should match one-shot")
    func testCRC32CIncremental() async throws {
        let testString = "123456789"
        let expectedCRC: UInt32 = 0xE3069283
        
        var crc = CyclicRedundancyCheck(algorithm: .crc32C)
        
        // One-shot computation
        let oneshotResult = crc.compute(string: testString)
        #expect(oneshotResult == expectedCRC)
        
        // Incremental computation
        crc.reset()
        crc.update(with: "123")
        crc.update(with: "456")
        crc.update(with: "789")
        let incrementalResult = crc.checksum
        
        #expect(incrementalResult == expectedCRC, "Incremental CRC32C should match one-shot result")
        #expect(incrementalResult == oneshotResult, "Incremental and one-shot should produce same result")
    }
    
    @Test("CRC32C should handle various byte patterns")
    func testCRC32CBytePatterns() async throws {
        // Test with all zeros
        let allZeros = Data(repeating: 0x00, count: 32)
        let zerosResult = CyclicRedundancyCheck.crc32c(bytes: allZeros)
        
        // Test with all ones
        let allOnes = Data(repeating: 0xFF, count: 32)
        let onesResult = CyclicRedundancyCheck.crc32c(bytes: allOnes)
        
        // Test with alternating bits
        let alternating = Data(repeating: 0xAA, count: 32)
        let alternatingResult = CyclicRedundancyCheck.crc32c(bytes: alternating)
        
        // Different patterns should produce different CRCs
        #expect(zerosResult != onesResult)
        #expect(zerosResult != alternatingResult)
        #expect(onesResult != alternatingResult)
    }
}