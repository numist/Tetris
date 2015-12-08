import XCTest
import CoreTetris

class TetriminoTests: XCTestCase {
    func permuteShapesAndRotations(work: (Tetrimino) -> Void) {
        for tetriminoShape in TetriminoShape.allValues {
            for i in 0..<4 {
                work(Tetrimino(shape: tetriminoShape, rotation: i))
            }
        }
    }
    
    func testPrintingTetriminos() {
        permuteShapesAndRotations { print($0) }
    }
    
    func testTetriminosHaveFourPoints() {
        permuteShapesAndRotations { XCTAssertEqual($0.points.count, 4) }
    }
    
    func testTetriminosHaveDifferentColors() {
        var colors = TetriminoShape.allValues.map { $0.color }
        while colors.count > 0 {
            let color = colors.removeFirst()
            for element in colors {
                XCTAssertFalse(element == color)
            }
        }
    }
    
    func testNonOTetriminosHaveDifferentPoints() {
        var tetriminoList = TetriminoShape.allValues.filter { shape in
            switch shape {
            case .O:
                return false
            default:
                return true
            }
        }.flatMap { shape in
            (0..<4).map { rotation in
                Tetrimino(shape: shape, rotation: rotation)
            }
        }
        while tetriminoList.count > 0 {
            let points = tetriminoList.removeFirst().points
            for tetrimino in tetriminoList {
                XCTAssertFalse(tetrimino.points == points)
            }
        }
    }
    
    func testTetriminoRotationSanity() {
        // Test that these calls do not throw
        permuteShapesAndRotations { $0.rotated(true) }
        permuteShapesAndRotations { $0.rotated(false) }
        
        // Test that rotating forward and back results in equal tetriminos
        permuteShapesAndRotations { XCTAssertTrue($0.rotated(false).rotated(true) == $0) }
    }
    
    func testTetriminoRotationWrapping() {
        permuteShapesAndRotations { XCTAssertTrue($0.rotated(true).rotated(true).rotated(true).rotated(true) == $0) }
        permuteShapesAndRotations { XCTAssertTrue($0.rotated(false).rotated(false).rotated(false).rotated(false) == $0) }
    }
    
    func testTetriminoRotationEqualities() {
        permuteShapesAndRotations { tetrimino in
            switch tetrimino.shape {
            case .O:
                XCTAssertTrue(tetrimino.rotated(true) == tetrimino)
            default:
                XCTAssertFalse(tetrimino.rotated(true) == tetrimino)
            }
        }
    }
}
