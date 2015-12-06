import XCTest
@testable import CoreTetris

class TetriminoGeneratorTests: XCTestCase {
    func testRandomGenerator() {
        var shapes: [TetriminoType] = []
        let generator = RandomGenerator()
        for _ in 0..<TetriminoType.allValues.count {
            let next = generator.next().shape
            XCTAssert(!shapes.contains(next))
            shapes.append(next)
        }
        for _ in 0..<TetriminoType.allValues.count {
            let next = generator.next().shape
            XCTAssert(shapes.contains(next))
            if let index = shapes.indexOf(next) {
                shapes.removeAtIndex(index)
            }
        }
        XCTAssert(shapes.count == 0)
    }
}
