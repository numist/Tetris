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

    func testGameOverCondition() {
        var state = GameState(generator: RandomGenerator(generator: FibonacciLinearFeedbackShiftRegister16()))
        
        for _ in 0..<11 {
            state = state.withHardDrop()
        }
        XCTAssert(!state.gameOver)
        XCTAssertNotNil(state.ghostPiece)
        state = state.movedDown()
        XCTAssert(state.gameOver)
        
        print(state.playfield)
        
        XCTAssertNil(state.ghostPiece)
        XCTAssertNil(state.activePiece)
        
        var score = state.score
        state = state.movedDown()
        XCTAssertEqual(score, state.score)
        score = state.score
        
        state = state.movedLeft()
        XCTAssertEqual(score, state.score)
        score = state.score
        
        state = state.movedRight()
        XCTAssertEqual(score, state.score)
        score = state.score
        
        state = state.rotatedCCW()
        XCTAssertEqual(score, state.score)
        score = state.score
        
        state = state.rotatedCW()
        XCTAssertEqual(score, state.score)
        score = state.score
        
        state = state.withHardDrop()
        XCTAssertEqual(score, state.score)
    }

    func testLineClearing() {
        let testGenerator = TestGenerator(list: [.I,.I,.O,.I,.I])
        var state = GameState(generator: testGenerator)
        
        // .I
        state = state.movedLeft().movedLeft().movedLeft().withHardDrop()
        // .I
        state = state.movedRight().movedRight().movedRight().withHardDrop()
        // .O
        state = state.withHardDrop()
        
        // |          |
        // |    OO    |
        // +----------+
        XCTAssertEqual(Set([Int2D(x: 4, y:19), Int2D(x: 5, y:19)]), state.playfield.points)
        
        // .I
        state = state.movedLeft().movedLeft().movedLeft().withHardDrop()
        // .I
        state = state.movedRight().movedRight().movedRight().withHardDrop()
        
        // |          |
        // +----------+
        XCTAssertEqual(Set(), state.playfield.points)
    }
    
    func testLineClearingAboveGarbage() {
        let testGenerator = TestGenerator(list: [.I,.I,.O])
        var state = GameState(generator: testGenerator)
        
        // .I
        state = state.movedLeft().movedLeft().withHardDrop()
        // .I
        state = state.movedRight().movedRight().withHardDrop()
        // .O
        state = state.withHardDrop()
        // .I
        state = state.movedLeft().movedLeft().movedLeft().withHardDrop()
        // .I
        state = state.movedRight().movedRight().movedRight().withHardDrop()
        
        // |          |
        // |    OO    |
        // | IIIIIIII |
        // +----------+
        XCTAssertEqual(Set([Int2D(x: 8, y: 19), Int2D(x: 5, y: 18), Int2D(x: 2, y: 19), Int2D(x: 1, y: 19), Int2D(x: 5, y: 19), Int2D(x: 7, y: 19), Int2D(x: 4, y: 18), Int2D(x: 4, y: 19), Int2D(x: 3, y: 19), Int2D(x: 6, y: 19)]), state.playfield.points)
    }

    func testPieceSpawnsAbovePlayfield() {
        let testGenerator = TestGenerator(list: [.I])
        let state = GameState(generator: testGenerator)
        
        XCTAssertEqual(Set([Int2D(x:3, y:-1), Int2D(x:4, y:-1), Int2D(x:5, y:-1), Int2D(x:6, y:-1)]), state.activePiece!.points)
        XCTAssertEqual(Set([Int2D(x:3, y:0), Int2D(x:4, y:0), Int2D(x:5, y:0), Int2D(x:6, y:0)]), state.movedDown().activePiece!.points)
    }

    func testGhostPieceAtBottomOfPlayfield() {
        let testGenerator = TestGenerator(list: [.I])
        let state = GameState(generator: testGenerator)
        
        // |          |
        // |   ....   |
        // +----------+
        let bottomY = state.playfield.height - 1
        XCTAssertEqual(Set([Int2D(x:3, y:bottomY), Int2D(x:4, y:bottomY), Int2D(x:5, y:bottomY), Int2D(x:6, y:bottomY)]), state.ghostPiece!.points)
    }
    
    func testGhostPieceOnTopOfOtherPieces() {
        let testGenerator = TestGenerator(list: [.I])
        let state = GameState(generator: testGenerator).withHardDrop()
        
        print(state)
        
        // |          |
        // |   ....   |
        // |   IIII   |
        // +----------+
        let ghostY = state.playfield.height - 2
        XCTAssertEqual(Set([Int2D(x:3, y:ghostY), Int2D(x:4, y:ghostY), Int2D(x:5, y:ghostY), Int2D(x:6, y:ghostY)]), state.ghostPiece!.points)
    }

    func testPieceRotation() {
        let testGenerator = TestGenerator(list: [.T])
        let state = GameState(generator: testGenerator).movedDown().movedDown()
        
        print(state.rotatedCW())
        
        XCTAssertEqual(Set([Int2D(x: 3, y: 1), Int2D(x: 5, y: 1), Int2D(x: 4, y: 2), Int2D(x: 4, y: 1)]), state.rotatedCCW().rotatedCCW().activePiece?.points)
    }
}
