extension Tetrimino: CustomStringConvertible {
    public var description: String { get {
        var coordinates: [[Bool]]
        let points = self.shape.points(self.rotation)
        
        switch self.shape {
        case .I:
            coordinates = [[Bool]](count:4, repeatedValue:[Bool](count:4, repeatedValue:false))
        case .O:
            coordinates = [[Bool]](count:3, repeatedValue:[Bool](count:4, repeatedValue:false))
        case .T, .J, .L, .S, .Z:
            coordinates = [[Bool]](count:3, repeatedValue:[Bool](count:3, repeatedValue:false))
        }
        
        for point in points {
            coordinates[point.y][point.x] = true
        }
        
        // Header
        var result = "+"
        for _ in 0..<coordinates[0].count {
            result += "-"
        }
        result += "+\n"
        
        // Rows (y axis grows downward)
        for i in 0..<coordinates.count {
            // Columns, lowest to highest
            result += "|"
            for j in 0..<coordinates[i].count {
                if (coordinates[i][j]) {
                    result += "#"
                } else {
                    result += " "
                }
            }
            result += "|\n"
        }
        
        // Footer
        result += "+"
        for _ in 0..<coordinates[0].count {
            result += "-"
        }
        result += "+"
        
        return result
        }}
}

extension Playfield: CustomStringConvertible {
    private var matrix: [[TetriminoShape?]] { get {
        var result = [[TetriminoShape?]](count: self.height, repeatedValue: [TetriminoShape?](count: self.width, repeatedValue: nil))
        for y in 0..<self.height {
            for x in 0..<self.width {
                if let shape = self.cells[Int2D(x: x, y: y)] {
                    result[y][x] = shape
                }
            }
        }
        return result
        } }
    
    public var description: String { get {
        // Header
        var result = "+"
        for _ in 0..<self.width {
            result += "-"
        }
        result += "+\n"
        
        // Rows (y axis grows downward)
        let matrix = self.matrix
        precondition(matrix.count == self.height)
        for row in matrix {
            result += "|"
            precondition(row.count == self.width)
            for cell in row {
                if let shape = cell {
                    result += shape.letter
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

extension GameState: CustomStringConvertible {
    public var description: String { get {
        
        // Header
        var result = "+"
        for _ in 0..<self.playfield.width {
            result += "-"
        }
        result += "+\n"
        
        // Rows (y axis grows downward)
        let matrix = self.playfield.matrix
        precondition(matrix.count == self.playfield.height)
        for y in 0..<matrix.count {
            result += "|"
            let row = matrix[y]
            precondition(row.count == self.playfield.width)
            for x in 0..<row.count {
                let cell = row[x]
                if let shape = cell {
                    result += shape.letter
                } else if let activePiece = self.activePiece where activePiece.points.contains(Int2D(x: x, y: y)) {
                    result += activePiece.tetrimino.shape.letter
                } else if let ghostPiece = self.ghostPiece where ghostPiece.points.contains(Int2D(x: x, y: y)) {
                    result += "."
                } else {
                    result += " "
                }
            }
            result += "|\n"
        }
        
        // Footer
        result += "+"
        for _ in 0..<self.playfield.width {
            result += "-"
        }
        result += "+"
        
        return result
        } }
}
