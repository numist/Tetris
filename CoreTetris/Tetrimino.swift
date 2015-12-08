public typealias TetriminoPoints = Set<Int2D>

public enum TetriminoShape {
    case I, O, T, J, L, S, Z
    
    public static let allValues: [TetriminoShape] = [.I, .O, .T, .J, .L, .S, .Z]
    
    private func _points() -> TetriminoPoints {
        // Origin is top left, y increases downward
        switch self {
        case .I:
            return [Int2D(x:0, y:1), Int2D(x:1, y:1), Int2D(x:2, y:1), Int2D(x:3, y:1)]
        case .O:
            return [Int2D(x:1, y:0), Int2D(x:2, y:0), Int2D(x:1, y:1), Int2D(x:2, y:1)]
        case .T:
            return [Int2D(x:1, y:0), Int2D(x:0, y:1), Int2D(x:1, y:1), Int2D(x:2, y:1)]
        case .J:
            return [Int2D(x:0, y:0), Int2D(x:0, y:1), Int2D(x:1, y:1), Int2D(x:2, y:1)]
        case .L:
            return [Int2D(x:2, y:0), Int2D(x:0, y:1), Int2D(x:1, y:1), Int2D(x:2, y:1)]
        case .S:
            return [Int2D(x:1, y:0), Int2D(x:2, y:0), Int2D(x:0, y:1), Int2D(x:1, y:1)]
        case .Z:
            return [Int2D(x:0, y:0), Int2D(x:1, y:0), Int2D(x:1, y:1), Int2D(x:2, y:1)]
        }
    }
    
    private func _rotationCenter() -> Double2D {
        switch self {
        case .I:
            return Double2D(x:1.5, y:1.5)
        case .O:
            assertionFailure(".O does not change under rotation")
            return Double2D(x:1.5, y:0.5)
        case .T, .J, .L, .S, .Z:
            return Double2D(x:1, y:1)
        }
    }
    
    // Rotation follows the rules of the [Super Rotation System](http://tetris.wikia.com/wiki/SRS)
    public func points(rotation: Int = 0) -> TetriminoPoints {
        switch self {
        case .O: return self._points()
        default: ()
        }
        
        let cos: Double, sin: Double
        switch rotation %% 4 {
        case 0:
            return self._points()
        case 1:
            // 90° CW
            sin = 1
            cos = 0
        case 2:
            // 180°
            sin = 0
            cos = -1
        case 3:
            // 90° CCW
            sin = -1
            cos = 0
        default:
            preconditionFailure()
        }
        
        let center = self._rotationCenter()
        
        // The below should have been return Set(points->map->map->map), but "Expression was too complex to be solved in reasonable time; consider breaking up the expression into distinct sub-expressions"

        // 1. Convert tetrimino points to Double2D
        let points = self._points().map({ Double2D(v:$0) })
        
        // 2. Translate points with respect to the rotational center
        let translatedPoints = points.map({ $0 - center })
        
        // 3. Perform the rotation
        // This uses a private function because the compiler was having a lot of trouble inferring types
        func rotatePoint(v: Double2D, sin: Double, cos: Double) -> Double2D {
            return Double2D(x:(v.x * cos) - (v.y * sin), y:(v.x * sin) + (v.y * cos))
        }
        let translatedRotatedPoints = translatedPoints.map({ rotatePoint($0, sin: sin, cos: cos) })
        
        // 4. Translate points back to the origin
        let rotatedPoints = translatedRotatedPoints.map({ $0 + center })
        
        // 5. Convert back to Int2D
        return Set(rotatedPoints.map({ Int2D(v: $0) }))
    }
    
    public var color: Color { get {
        switch self {
        case .I: return Color.cyan
        case .O: return Color.yellow
        case .T: return Color.purple
        case .J: return Color.blue
        case .L: return Color.orange
        case .S: return Color.green
        case .Z: return Color.red
        }
    }}
}

public func ==(left: Tetrimino, right: Tetrimino) -> Bool {
    return left.shape == right.shape && left.points == right.points
}

public struct Tetrimino: Equatable {
    public let shape: TetriminoShape

    private let rotation: Int

    public init(shape: TetriminoShape, rotation: Int = 0) {
        self.shape = shape
        self.rotation = rotation %% 4
    }
    
    public var points: TetriminoPoints { get {
        return self.shape.points(self.rotation)
    }}

    public func rotated(clockwise: Bool) -> Tetrimino {
        switch self.shape {
        case .O: return self
        default:
            let newRotation = self.rotation + (clockwise ? 1 : -1)
            return Tetrimino(shape: self.shape, rotation: newRotation)
        }
    }
}

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
