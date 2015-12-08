//
//  GameStateTests.swift
//  Tetris
//
//  Created by Scott Perry on 12/06/15.
//  Copyright © 2015 Scott Perry. All rights reserved.
//

import XCTest
import CoreTetris

final class TestGenerator: TetriminoGenerator {
    private let tetriminos: [TetriminoShape]
    private var index: Int
    
    init(list: [TetriminoShape], index: Int = 0) {
        precondition(list.count > 0)
        self.tetriminos = list
        self.index = index
    }
    
    func next() -> TetriminoShape {
        let result = self.tetriminos[self.index]
        self.index = (self.index + 1) % self.tetriminos.count
        return result
    }
    
    func copy() -> TestGenerator {
        return TestGenerator(list: self.tetriminos, index: self.index)
    }
}

class GameStateTests: XCTestCase {

//    func testGameStuff() {
//        var state = GameState(generator: RandomGenerator(generator: FibonacciLinearFeedbackShiftRegister16()))
//        
//        for _ in 0..<100 {
//            state = state.withHardDrop()
//        }
//        XCTAssert(state.gameOver)
//    }

    func testLineClearing() {
        let testGenerator = TestGenerator(list: [.I,.I,.O])
        var state = GameState(generator: testGenerator)
        state = state.movedLeft().movedLeft().movedLeft().withHardDrop()
        state = state.movedRight().movedRight().movedRight().withHardDrop()
        state = state.withHardDrop()
        XCTAssertEqual(Set([Int2D(x: 4, y:19), Int2D(x: 5, y:19)]), state.playfield.points)
    }

    func testPieceSpawnsAbovePlayfield() {
        let testGenerator = TestGenerator(list: [.I])
        let state = GameState(generator: testGenerator)
        
        XCTAssertEqual(Set([Int2D(x:3, y:-1), Int2D(x:4, y:-1), Int2D(x:5, y:-1), Int2D(x:6, y:-1)]), state.activePiece!.points)
    }

    func testGhostPieceAtBottomOfPlayfield() {
        let testGenerator = TestGenerator(list: [.I])
        let state = GameState(generator: testGenerator)
        
        let bottomY = state.playfield.height - 1
        XCTAssertEqual(Set([Int2D(x:3, y:bottomY), Int2D(x:4, y:bottomY), Int2D(x:5, y:bottomY), Int2D(x:6, y:bottomY)]), state.ghostPiece!.points)
    }

}
