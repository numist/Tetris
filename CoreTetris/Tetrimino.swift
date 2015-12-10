public typealias TetriminoPoints = Set<Int2D>

public enum TetriminoShape {
    case I, O, T, J, L, S, Z
    
    public static let allValues: [TetriminoShape] = [.I, .O, .T, .J, .L, .S, .Z]
    
    public var letter: String { get {
        switch self {
        case .I: return "I"
        case .O: return "O"
        case .T: return "T"
        case .J: return "J"
        case .L: return "L"
        case .S: return "S"
        case .Z: return "Z"
        }
    } }
    
    var initialPosition: Int2D { get {
        switch self {
        case .I: return Int2D(x: -2, y: -3)
        default: return Int2D(x: -1, y: -2)
        }
    } }
    
    private func _points() -> TetriminoPoints {
        // Origin is top left, y increases downward
        switch self {
        case .I:
            return [Int2D(x:1, y:2), Int2D(x:2, y:2), Int2D(x:3, y:2), Int2D(x:4, y:2)]
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
    
    // Rotation follows the rules of the [Super Rotation System](http://harddrop.com/wiki/SRS)
    private func rotationCenter() -> Int2D {
        switch self {
        case .I:
            return Int2D(x:2, y:2)
        case .T, .J, .L, .S, .Z, .O:
            return Int2D(x:1, y:1)
        }
    }
    
    func offset(index: Int, rotation: Int) -> Int2D? {
        precondition(rotation >= 0 && rotation < 4)
        
        let offsets: [[Int2D]]
        switch self {
        case .J, .L, .S, .T, .Z:
            offsets = [
                [Int2D(x: 0, y: 0), Int2D(x: 0, y: 0), Int2D(x: 0, y: 0), Int2D(x: 0, y: 0), Int2D(x: 0, y: 0)],
                [Int2D(x: 0, y: 0), Int2D(x: 1, y: 0), Int2D(x: 1, y: -1), Int2D(x: 0, y: 2), Int2D(x: 1, y: 2)],
                [Int2D(x: 0, y: 0), Int2D(x: 0, y: 0), Int2D(x: 0, y: 0), Int2D(x: 0, y: 0), Int2D(x: 0, y: 0)],
                [Int2D(x: 0, y: 0), Int2D(x: -1, y: 0), Int2D(x: -1, y: -1), Int2D(x: 0, y: 2), Int2D(x: -1, y: 2)]
            ]
        case .I:
            offsets = [
                [Int2D(x: 0, y: 0), Int2D(x: -1, y: 0), Int2D(x: 2, y: 0), Int2D(x: -1, y: 0), Int2D(x: 2, y: 0)],
                [Int2D(x: -1, y: 0), Int2D(x: 0, y: 0), Int2D(x: 0, y: 0), Int2D(x: 0, y: 1), Int2D(x: 0, y: -2)],
                [Int2D(x: -1, y: 1), Int2D(x: 1, y: 1), Int2D(x: -2, y: 1), Int2D(x: 1, y: 0), Int2D(x: -2, y: 0)],
                [Int2D(x: 0, y: 1), Int2D(x: 0, y: 1), Int2D(x: 0, y: 1), Int2D(x: 0, y: -1), Int2D(x: 0, y: 2)]
            ]
        case .O:
            offsets = [[Int2D(x: 0, y: 0)], [Int2D(x: 0, y: -1)], [Int2D(x: -1, y: -1)], [Int2D(x: -1, y: 0)]]
        }
        
        if index >= offsets[rotation].count {
            return nil
        }
        return offsets[rotation][index]
    }
    
    public func points(rotation: Int = 0, offset: Int = 0) -> TetriminoPoints {
        let cos: Int, sin: Int
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
        
        let center = self.rotationCenter()
        
        // The below should have been return Set(points->map->map->map), but "Expression was too complex to be solved in reasonable time; consider breaking up the expression into distinct sub-expressions"

        // 1. Translate points with respect to the rotational center
        let translatedPoints = self._points().map({ $0 - center })
        
        // 2. Perform the rotation
        // This uses a private function because the compiler was having a lot of trouble inferring types
        func rotatePoint(v: Int2D, sin: Int, cos: Int) -> Int2D {
            return Int2D(x:(v.x * cos) - (v.y * sin), y:(v.x * sin) + (v.y * cos))
        }
        let translatedRotatedPoints = translatedPoints.map({ rotatePoint($0, sin: sin, cos: cos) })
        
        // 3. Translate points back to the origin
        let rotatedPoints = translatedRotatedPoints.map({ $0 + center })
        
        // 4. Convert collection to Set
        return Set(rotatedPoints)
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

    let rotation: Int

    public init(shape: TetriminoShape, rotation: Int = 0) {
        self.shape = shape
        self.rotation = rotation %% 4
    }
    
    public var points: TetriminoPoints { get {
        return self.shape.points(self.rotation)
    }}
    
    func offset(index: Int) -> Int2D? {
        return self.shape.offset(index, rotation: self.rotation)
    }

    public func rotated(clockwise: Bool) -> Tetrimino {
        switch self.shape {
        case .O: return self
        default:
            let newRotation = self.rotation + (clockwise ? 1 : -1)
            return Tetrimino(shape: self.shape, rotation: newRotation)
        }
    }
}
