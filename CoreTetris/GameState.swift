struct Playfield {
    let width: Int = 10
    let height: Int = 20
    let cells: [Int2D:TetriminoType]
    var points: Set<Int2D> { get {
        // TODO: this is slow
        return Set(self.cells.keys)
    } }
}

extension Array {
    func appending(newElement: Element) -> [Element] {
        var result = self
        result.append(newElement)
        return result
    }
}

struct GamePiece {
    let tetrimino: Tetrimino
    let position: Int2D
    var points: TetriminoPoints { get {
        return Set(self.tetrimino.points.map({ $0 + self.position }))
    } }
}

struct GameState {
    let score: Int
    let playfield: Playfield
    // TODO: This should be a TetriminoGenerator, RandomGenerator should be a struct, and it should be deterministic, using an LFSR
    let pieceQueue: [TetriminoType]
    let activePiece: GamePiece?
    var gameOver: Bool { get {
        return self.activePiece == nil
    } }
    
    init(var pieceQueue: [TetriminoType]) {
        self.score = 0
        self.playfield = Playfield(cells:[:])
        self.activePiece = GamePiece(tetrimino: Tetrimino(shape: pieceQueue.removeFirst()), position: Int2D(x:((self.playfield.width / 2) - 2), y:0))
        self.pieceQueue = pieceQueue
    }
    
    private init(score: Int, playfield: Playfield, pieceQueue: [TetriminoType], activePiece: GamePiece?) {
        self.score = score
        self.playfield = playfield
        self.pieceQueue = pieceQueue
        self.activePiece = activePiece
    }
    
    // TODO: this should go away
    func addingPiece(piece: TetriminoType) -> GameState {
        if self.gameOver {
            return self
        }
        return GameState(score: self.score, playfield: self.playfield, pieceQueue: self.pieceQueue.appending(piece), activePiece: self.activePiece)
    }
    
    func rotatedCW() -> GameState {
        if self.gameOver || self.activePiece == nil {
            return self
        }
        // TODO
        return self
    }
    
    func rotatedCCW() -> GameState {
        if self.gameOver || self.activePiece == nil {
            return self
        }
        // TODO
        return self
    }
    
    func hardDropped() -> GameState {
        if self.gameOver || self.activePiece == nil {
            return self
        }
        // TODO
        return self
    }
    
    func softDropped() -> GameState {
        if self.gameOver || self.activePiece == nil {
            return self
        }
        // TODO
        return self
    }
    
    func movedLeft() -> GameState {
        if self.gameOver || self.activePiece == nil {
            return self
        }
        let newPoints = Set(self.activePiece!.points.map({ $0 - Int2D(x:1, y:0) }))
        if newPoints.intersect(self.playfield.points).count > 0 {
            // Illegal move, no change
            return self
        }
        if newPoints.filter({ $0.x < 0 }).count > 0 {
            // Illegal move, no change
            return self
        }
        // TODO
        return self
    }
    
    func movedRight() -> GameState {
        if self.gameOver || self.activePiece == nil {
            return self
        }
        // TODO
        return self
    }
}
