//
//  MathTests.swift
//  Tetris
//
//  Created by Scott Perry on 12/06/15.
//  Copyright © 2015 Scott Perry. All rights reserved.
//

import XCTest
import CoreTetris

class MathTests: XCTestCase {
    func testLFSR() {
        let lfsr = (try? FibonacciLinearFeedbackShiftRegister16(seed: 0x8988, taps: [1, 9]))!
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
}
