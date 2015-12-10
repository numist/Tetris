public enum Gravity {
    case Naïve //, Sticky, Cascade
}

public struct Playfield {
    public let width: Int = 10
    public let height: Int = 20
    public let cells: [Int2D:TetriminoShape]
    public let points: Set<Int2D>
    
    private init(cells: [Int2D:TetriminoShape]) {
        self.cells = cells
        self.points = Set(cells.keys)
    }
    
    private func bake(piece: GamePiece) -> Playfield {
        precondition(piece.points.intersect(self.points).count == 0)
        
        var newCells = self.cells
        for point in piece.points {
            newCells[point] = piece.tetrimino.shape
        }
        return Playfield(cells: newCells)
    }
    
    private func remove(line: Int) -> Playfield {
        var newCells = [Int2D:TetriminoShape]()
        
        for (point, shape) in self.cells {
            if point.y > line {
                newCells[point] = shape
            } else if point.y < line {
                newCells[Int2D(x: point.x, y: point.y + 1)] = shape
            }
        }
        
        return Playfield(cells: newCells)
    }
    
    private func intersects(piece: GamePiece) -> Bool {
        for point in piece.points {
            if let _ = self.cells[point] {
                return true
            }
            if point.x < 0 || point.x >= self.width || point.y >= self.height {
                return true
            }
        }
        return false
    }
}

private func -(left: GamePiece, right: Int2D) -> GamePiece {
    return left.with(position: left.position - right)
}

private func +(left: GamePiece, right: Int2D) -> GamePiece {
    return left.with(position: left.position + right)
}

public func ==(left: GamePiece, right: GamePiece) -> Bool {
    return left.points == right.points && left.tetrimino.shape == right.tetrimino.shape
}

public struct GamePiece {
    public let tetrimino: Tetrimino
    let position: Int2D
    public let points: TetriminoPoints

    private init(tetrimino: Tetrimino, position: Int2D) {
        self.tetrimino = tetrimino
        self.position = position
        self.points = Set(tetrimino.points.map({ $0 + position }))
    }
    
    private func with(tetrimino tetrimino: Tetrimino) -> GamePiece {
        return GamePiece(tetrimino: tetrimino, position: self.position)
    }

    private func with(position position: Int2D) -> GamePiece {
        return GamePiece(tetrimino: self.tetrimino, position: position)
    }
}

// TODO: preview window
// TODO: smarter starting offsets
private func spawnPiece(shape: TetriminoShape, width: Int) -> GamePiece {
    return GamePiece(tetrimino: Tetrimino(shape: shape), position: shape.initialPosition + Int2D(x:((width - 1) / 2), y:0))
}

private func generateGhost(activePiece activePiece: GamePiece?, playfield: Playfield) -> GamePiece? {
    guard var ghostPiece = activePiece else { return nil }
    assert(!playfield.intersects(ghostPiece))
    
    // RILF: Expected 'while' after body of 'repeat' statement
    // repeat { // Infinite loop
    while true {
        ghostPiece = ghostPiece + Int2D(x:0, y:1)
        if playfield.intersects(ghostPiece) {
            ghostPiece = ghostPiece - Int2D(x:0, y:1)
            break
        }
    }
    return ghostPiece
}

public struct GameState {
    public let score: Int
    public let playfield: Playfield
    public let activePiece: GamePiece?
    public let ghostPiece: GamePiece?
    
    private let generator: TetriminoGenerator
    private let gravity: Gravity
    
    public var gameOver: Bool { get {
        return self.activePiece == nil
    }}

    public init(generator: TetriminoGenerator, gravity: Gravity = .Naïve) {
        self.score = 0
        self.playfield = Playfield(cells:[:])
        self.activePiece = spawnPiece(generator.next(), width: self.playfield.width)
        self.generator = generator
        self.gravity = gravity
        // RILF: computed properties with immutable dependencies should be automatically memoized
        // RILF: lazy let
        self.ghostPiece = generateGhost(activePiece: self.activePiece, playfield: self.playfield)
    }

    private init(score: Int, playfield: Playfield, generator: TetriminoGenerator, activePiece: GamePiece?, gravity: Gravity) {
        self.score = score
        self.playfield = playfield
        self.generator = generator
        self.activePiece = activePiece
        self.gravity = gravity
        // RILF: computed properties with immutable dependencies should be automatically memoized
        // RILF: lazy let
        self.ghostPiece = generateGhost(activePiece: self.activePiece, playfield: self.playfield)
    }
    
    // TODO: Rename to lock
    private func bake() -> GameState {
        guard let activePiece = self.activePiece else {
            preconditionFailure()
        }
        assert(activePiece == self.ghostPiece!)
        
        var newPlayfield = self.playfield.bake(activePiece)
        
        // Completed rows are all rows that have `playfield.width` cells set
        let completedRows = newPlayfield.points.reduce([Int:Int](), combine: { accum, elem in
            var newAccum = accum
            newAccum[elem.y] = (newAccum[elem.y] ?? 0) + 1
            return newAccum
        }).filter({ return $1 == newPlayfield.width }).map({ $0.0 }).sort()
        
        if completedRows.count > 0 {
            for rowNumber in completedRows {
                newPlayfield = newPlayfield.remove(rowNumber)
            }
            
            // Regression assertion for a bug where unordered completedRows caused the wrong rows to be removed from playfield
            assert(newPlayfield.points.reduce([Int:Int](), combine: { accum, elem in
                var newAccum = accum
                newAccum[elem.y] = (newAccum[elem.y] ?? 0) + 1
                return newAccum
            }).filter({ return $1 == newPlayfield.width }).count == 0)

            switch self.gravity {
            case .Naïve: break
            }
        }
        
        let newPiece = spawnPiece(self.generator.next(), width: newPlayfield.width)
        
        if newPlayfield.intersects(newPiece) {
            return with(nil, newPlayfield: newPlayfield)
        }
        return with(newPiece, newPlayfield: newPlayfield)
    }
    
    // RILF: Use of unresolved identifier 'self'
    // private func with(score: Int = self.score, playfield: Playfield = self.playfield, activePiece: GamePiece? = self.activePiece) -> GameState {
    private func with(activePiece: GamePiece?, newScore: Int? = nil, newPlayfield: Playfield? = nil) -> GameState {
        let playfield = newPlayfield ?? self.playfield
        let score = newScore ?? self.score
        
        if let newPiece = activePiece {
            assert(!playfield.intersects(newPiece))
        }
        
        return GameState(score: score, playfield: playfield, generator: self.generator.copy(), activePiece: activePiece, gravity: self.gravity)
    }
    
    // TODO: 180° support?
    public func rotated(clockwise clockwise: Bool) -> GameState {
        guard let activePiece = self.activePiece else {
            return self
        }
        
        let basePiece = activePiece.with(tetrimino: activePiece.tetrimino.rotated(clockwise))
        var newPiece: GamePiece? = nil
        do {
            var index = 0
            repeat {
                guard let originalOffset = activePiece.tetrimino.offset(index), newOffset = basePiece.tetrimino.offset(index) else {
                    break
                }
                let kickTranslation = originalOffset - newOffset
                newPiece = basePiece + kickTranslation
                index += 1
            } while playfield.intersects(newPiece!)
        }
        
        if newPiece == nil || playfield.intersects(newPiece!) {
            return self
        }
        return self.with(newPiece)
    }
    
    public func withHardDrop() -> GameState {
        // The ghost piece is by definition located where this piece will land on a hard drop.
        guard let newPiece = self.ghostPiece else {
            return self
        }
        
        // TODO: do hard drops add to the score?
        // Yes, and so do soft drops. Score should probably not be part of GameState since it also depends on level.
        return with(newPiece).bake()
    }
    
    public func movedDown() -> GameState {
        guard let activePiece = self.activePiece else {
            return self
        }
        
        if activePiece == self.ghostPiece! {
            return bake()
        }
        
        let newPiece = activePiece + Int2D(x:0, y:1)
        assert(!playfield.intersects(newPiece))
        return with(newPiece)
    }
    
    public func movedLeft() -> GameState {
        guard let activePiece = self.activePiece else {
            return self
        }
        let newPiece = activePiece - Int2D(x:1, y:0)
        if playfield.intersects(newPiece) {
            return self
        }
        return with(newPiece)
    }
    
    public func movedRight() -> GameState {
        guard let activePiece = self.activePiece else {
            return self
        }
        let newPiece = activePiece + Int2D(x:1, y:0)
        if playfield.intersects(newPiece) {
            return self
        }
        return with(newPiece)
    }
}
