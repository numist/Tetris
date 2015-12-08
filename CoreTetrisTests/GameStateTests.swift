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
    private var index: Int = 0
    
    init(list: [TetriminoShape]) {
        precondition(list.count > 0)
        self.tetriminos = list
    }
    
    func next() -> TetriminoShape {
        let result = self.tetriminos[self.index]
        self.index = (self.index + 1) % self.tetriminos.count
        return result
    }
    
    func copy() -> TestGenerator {
        return TestGenerator(list: self.tetriminos)
    }
}

class GameStateTests: XCTestCase {

    func testGameStuff() {
        var state = GameState(generator: RandomGenerator(generator: FibonacciLinearFeedbackShiftRegister16()))
        
        for _ in 0..<100 {
            state = state.withHardDrop()
        }
        XCTAssert(state.gameOver)
    }

    func testLineClearing() {
        let testGenerator = TestGenerator(list: [.I,.I,.O])
        var state = GameState(generator: testGenerator)
        state = state.movedLeft().movedLeft().movedLeft().movedLeft().withHardDrop()
        state = state.movedRight().movedRight().movedRight().movedRight().withHardDrop()
        state = state.withHardDrop()
    }
}
