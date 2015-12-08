import XCTest
import CoreTetris

class TetriminoGeneratorTests: XCTestCase {
    func testRandomGenerator() {
        var shapes: [TetriminoShape] = []
        let generator = RandomGenerator(generator: FibonacciLinearFeedbackShiftRegister16())
        for _ in 0..<TetriminoShape.allValues.count {
            let next = generator.next()
            XCTAssert(!shapes.contains(next))
            shapes.append(next)
        }
        for _ in 0..<TetriminoShape.allValues.count {
            let next = generator.next()
            XCTAssert(shapes.contains(next))
            if let index = shapes.indexOf(next) {
                shapes.removeAtIndex(index)
            }
        }
        XCTAssert(shapes.count == 0)
    }
    
    func testCopiesProduceSameValuesAsOriginal() {
        let generator1 = RandomGenerator(generator: FibonacciLinearFeedbackShiftRegister16())
        let generator2 = generator1.copy()
        
        for _ in 0..<(TetriminoShape.allValues.count * 2) {
            XCTAssertEqual(generator1.next(), generator2.next())
        }
    }
}
