public enum Gravity {
    case Naïve, Sticky, Cascade
}

public struct Playfield: CustomStringConvertible {
    public let width: Int = 10
    public let height: Int = 20
    public let cells: [Int2D:TetriminoShape]
    
    public var points: Set<Int2D> { get {
        // TODO: this is slow
        return Set(self.cells.keys)
    } }
    
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
    
    public var description: String { get {
        // Header
        var result = "+"
        for _ in 0..<self.width {
            result += "-"
        }
        result += "+\n"
        
        // Rows (y axis grows downward)
        for y in 0..<self.height {
            result += "|"
            for x in 0..<self.width {
                if let shape = self.cells[Int2D(x: x, y: y)] {
                    switch shape {
                    case .I: result += "I"
                    case .O: result += "O"
                    case .T: result += "T"
                    case .J: result += "J"
                    case .L: result += "L"
                    case .S: result += "S"
                    case .Z: result += "Z"
                    }
                } else {
                    result += " "
                }
            }
            result += "|\n"
        }
        
        // Footer
        result += "+"
        for _ in 0..<self.width {
            result += "-"
        }
        result += "+"
        
        return result
    } }
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
    public var points: TetriminoPoints { get {
        return Set(self.tetrimino.points.map({ $0 + self.position }))
    } }
    
    private func with(position position: Int2D? = nil, tetrimino: Tetrimino? = nil) -> GamePiece {
        return GamePiece(tetrimino: tetrimino ?? self.tetrimino, position: position ?? self.position)
    }
}

private func spawnPiece(shape: TetriminoShape, width: Int) -> GamePiece {
    return GamePiece(tetrimino: Tetrimino(shape: shape), position: Int2D(x:((width / 2) - 2), y:-2))
}

public struct GameState {
    public let score: Int
    public let playfield: Playfield
    public let activePiece: GamePiece?
    
    private let generator: TetriminoGenerator
    private let gravity: Gravity
    
    public var gameOver: Bool { get {
        return self.activePiece == nil
    }}

    // TODO: cache result, invalidate on sideways movement, rotation, and baking
    public var ghostPiece: GamePiece? { get {
        guard var ghostPiece = activePiece else { return nil }
    
        // RILF: Expected 'while' after body of 'repeat' statement
        // repeat { // Infinite loop
        while true {
            ghostPiece = ghostPiece + Int2D(x:0, y:1)
            let newPoints = ghostPiece.points
            let intersectsPlayfield = newPoints.intersect(self.playfield.points).count > 0
            let pastBottomOfPlayfield = newPoints.filter({ $0.y >= self.playfield.height }).count > 0
            if intersectsPlayfield || pastBottomOfPlayfield {
                ghostPiece = ghostPiece - Int2D(x:0, y:1)
                break
            }
        }
        return ghostPiece
    }}

    public init(generator: TetriminoGenerator, gravity: Gravity = .Naïve) {
        self.score = 0
        self.playfield = Playfield(cells:[:])
        self.activePiece = spawnPiece(generator.next(), width: self.playfield.width)
        self.generator = generator
        self.gravity = gravity
    }

    private init(score: Int, playfield: Playfield, generator: TetriminoGenerator, activePiece: GamePiece?, gravity: Gravity) {
        self.score = score
        self.playfield = playfield
        self.generator = generator
        self.activePiece = activePiece
        self.gravity = gravity
    }
    
    private func bake() -> GameState {
        guard let activePiece = self.activePiece else {
            preconditionFailure()
        }
        
        var newPlayfield = self.playfield.bake(activePiece)
        
        let completedRows = newPlayfield.points.reduce([Int:Int](), combine: { accum, elem in
            var newAccum = accum
            newAccum[elem.y] = (newAccum[elem.y] ?? 0) + 1
            return newAccum
        }).filter({ return $1 == self.playfield.width }).map({ $0.0 })
        
        completedRows.forEach({ newPlayfield = newPlayfield.remove($0) })
        
        if completedRows.count > 0 {
            switch self.gravity {
            case .Naïve: break
            default:
                assertionFailure("Not implemented")
            }
        }
        
        return with(spawnPiece(self.generator.next(), width: self.playfield.width), newPlayfield: newPlayfield)
    }
    
    // RILF: Use of unresolved identifier 'self'
    // private func with(score: Int = self.score, playfield: Playfield = self.playfield, activePiece: GamePiece? = self.activePiece) -> GameState {
    private func with(activePiece: GamePiece?, newScore: Int? = nil, newPlayfield: Playfield? = nil) -> GameState {
        let playfield = newPlayfield ?? self.playfield
        let score = newScore ?? self.score
        
        if let newPiece = activePiece {
            let newPoints = newPiece.points
            
            if newPoints.intersect(self.playfield.points).count > 0 {
                // New piece intersects cells in the playfield
                // TODO: floor kick?
                assertionFailure("Not implemented")
                return self
            }
            
            if newPoints.filter({ $0.y >= self.playfield.height }).count > 0 {
                // New piece extends below the bottom of the playfield
                // TODO: floor kick?
                assertionFailure("Not implemented")
                return self
            }
            
            if newPoints.filter({ $0.x < 0 }).count > 0 {
                // New piece extends last the left edge of the playfield
                // TODO: wall kick?
                assertionFailure("Not implemented")
                return self
            }
            
            if newPoints.filter({ $0.x >= self.playfield.width }).count > 0 {
                // New piece extends last the right edge of the playfield
                // TODO: wall kick?
                assertionFailure("Not implemented")
                return self
            }
        }
        
        return GameState(score: score, playfield: playfield, generator: self.generator.copy(), activePiece: activePiece, gravity: self.gravity)
    }
    
    public func rotatedCW() -> GameState {
        guard let activePiece = self.activePiece else {
            return self
        }
        
        return self.with(activePiece.with(tetrimino: activePiece.tetrimino.rotated(true)))
    }
    
    public func rotatedCCW() -> GameState {
        guard let activePiece = self.activePiece else {
            return self
        }

        return self.with(activePiece.with(tetrimino: activePiece.tetrimino.rotated(false)))
    }
    
    public func withHardDrop() -> GameState {
        // The ghost piece is by definition located where this piece will land on a hard drop.
        guard let newPiece = self.ghostPiece else {
            return self
        }
        
        // TODO: do hard drops add to the score?
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
        assert(newPiece.points.intersect(self.playfield.points).count == 0)
        assert(newPiece.points.filter({ $0.y >= self.playfield.height }).count == 0)
        return with(newPiece)
    }
    
    public func movedLeft() -> GameState {
        guard let activePiece = self.activePiece else {
            return self
        }
        return with(activePiece - Int2D(x:1, y:0))
    }
    
    public func movedRight() -> GameState {
        guard let activePiece = self.activePiece else {
            return self
        }
        return with(activePiece + Int2D(x:1, y:0))
    }
}
