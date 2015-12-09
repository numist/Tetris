import XCTest
import CoreTetris

class MathTests: XCTestCase {
    func testLFSR() {
        let lfsr = FibonacciLinearFeedbackShiftRegister16()
        XCTAssertEqual(lfsr.next(), 0x44C4)
        XCTAssertEqual(lfsr.next(), 0x2262)
        XCTAssertEqual(lfsr.next(), 0x1131)
        XCTAssertEqual(lfsr.next(), 0x0898)
        XCTAssertEqual(lfsr.next(), 0x044C)
        XCTAssertEqual(lfsr.next(), 0x0226)
        XCTAssertEqual(lfsr.next(), 0x0113)
        XCTAssertEqual(lfsr.next(), 0x8089)
        XCTAssertEqual(lfsr.next(), 0x4044)
    }
    
    func testCopyingLFSR() {
        let lfsr1 = FibonacciLinearFeedbackShiftRegister16()
        let lfsr2 = lfsr1.copy()
        XCTAssertEqual(lfsr1.next(), lfsr2.next())
        XCTAssertEqual(lfsr1.next(), lfsr2.next())
        XCTAssertEqual(lfsr1.next(), lfsr2.next())
    }
    
    func testLFSRZeroSeed() {
        do {
            // Cannot use a zero seed
            try FibonacciLinearFeedbackShiftRegister16(seed: 0, taps: [1,9]).next()
            XCTFail()
        } catch _ {}
    }
    
    func testLFSRInvalidTap() {
        do {
            // Cannot use a tap >= 16
            try FibonacciLinearFeedbackShiftRegister16(seed: 1, taps: [1,16]).next()
            XCTFail()
        } catch _ {}
    }
    
    func testLFSRInvalidTapCount() {
        do {
            // Cannot use less than two taps
            try FibonacciLinearFeedbackShiftRegister16(seed: 1, taps: [1]).next()
            XCTFail()
        } catch _ {}
    }
}
