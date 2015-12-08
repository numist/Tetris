import XCTest
import CoreTetris

class ColorTests: XCTestCase {
    func testColorsDifferByAlpha() {
        let c1 = Color(argb: 0x01000000)
        let c2 = Color(argb: 0x00000000)
        XCTAssert(c1 != c2)
    }

    func testColorsDifferByRed() {
        let c1 = Color(argb: 0x00010000)
        let c2 = Color(argb: 0x00000000)
        XCTAssert(c1 != c2)
    }

    func testColorsDifferByGreen() {
        let c1 = Color(argb: 0x00000100)
        let c2 = Color(argb: 0x00000000)
        XCTAssert(c1 != c2)
    }

    func testColorsDifferByBlue() {
        let c1 = Color(argb: 0x00000001)
        let c2 = Color(argb: 0x00000000)
        XCTAssert(c1 != c2)
    }
}
