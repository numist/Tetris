
func ==(left: Point, right: Point) -> Bool {
    return left.x == right.x && left.y == right.y
}

struct Point: Hashable {
    let x: Int
    let y: Int
    
    var hashValue: Int {
        return self.x ^ self.y << 16
    }
}

// TODO: Set<Point>
typealias TetriminoPoints = (Point, Point, Point, Point)

// Remainder operator has same properties as modulo
infix operator %% { associativity left precedence 150 }
func %%(left: Int, right: Int) -> Int {
    return (((left % right) + right) % right)
}

struct Color {
    let alpha: Double
    let red: Double
    let green: Double
    let blue: Double
    init(alpha: Int = 0, red: Int, green: Int, blue: Int) {
        precondition(alpha >= 0 && alpha < 256)
        precondition(red >= 0 && red < 256)
        precondition(green >= 0 && green < 256)
        precondition(blue >= 0 && blue < 256)
        
        self.alpha = Double(alpha) / 255
        self.red = Double(red) / 255
        self.green = Double(green) / 255
        self.blue = Double(blue) / 255
    }
    init(argb: Int32) {
        let alpha = Int(argb & (0xFF << 24))
        let red   = Int(argb & (0xFF << 16))
        let green = Int(argb & (0xFF << 8))
        let blue  = Int(argb & (0xFF << 0))
        self.init(alpha: alpha, red: red, green: green, blue: blue)
    }
}

enum TetriminoShape {
    case I, O, T, J, L, S, Z
    func points(rotation: Int = 0) -> TetriminoPoints {
        // Note: All ASCII art diagrams are using the lower left as (0,0)
        let result: TetriminoPoints
        switch self {
        case I:
            switch rotation %% 4 {
            case 0:
                /********/
                /**    **/
                /**XXXX**/
                /**    **/
                /**    **/
                /********/
                result = (Point(x:0, y:2), Point(x:1, y:2), Point(x:2, y:2), Point(x:3, y:2))
            case 1:
                /********/
                /**  X **/
                /**  X **/
                /**  X **/
                /**  X **/
                /********/
                result = (Point(x:2, y:0), Point(x:2, y:1), Point(x:2, y:2), Point(x:2, y:3))
            case 2:
                /********/
                /**    **/
                /**    **/
                /**XXXX**/
                /**    **/
                /********/
                result = (Point(x:0, y:1), Point(x:1, y:1), Point(x:2, y:1), Point(x:3, y:1))
            case 3:
                /********/
                /** X  **/
                /** X  **/
                /** X  **/
                /** X  **/
                /********/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            default:
                preconditionFailure()
            }
        case O:
            /********/
            /** XX **/
            /** XX **/
            /**    **/
            /********/
            result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
        case T:
            switch rotation %% 4 {
            case 0:
                /*******/
                /** X **/
                /**XXX**/
                /**   **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 1:
                /*******/
                /** X **/
                /** XX**/
                /** X **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))

            
            case 2:
                /*******/
                /**   **/
                /**XXX**/
                /** X **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 3:
                /********/
                /** X **/
                /**XX **/
                /** X **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            default:
                preconditionFailure()
            }
        case J:
            switch rotation %% 4 {
            case 0:
                /*******/
                /**X  **/
                /**XXX**/
                /**   **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 1:
                /*******/
                /** XX**/
                /** X **/
                /** X **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 2:
                /*******/
                /**   **/
                /**XXX**/
                /**  X**/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 3:
                /*******/
                /** X **/
                /** X **/
                /**XX **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            default:
                preconditionFailure()
            }
        case L:
            switch rotation %% 4 {
            case 0:
                /*******/
                /**  X**/
                /**XXX**/
                /**   **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 1:
                /*******/
                /** X **/
                /** X **/
                /** XX**/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 2:
                /*******/
                /**   **/
                /**XXX**/
                /**X  **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 3:
                /*******/
                /**XX **/
                /** X **/
                /** X **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            default:
                preconditionFailure()
            }
        case S:
            switch rotation %% 4 {
            case 0:
                /*******/
                /** XX**/
                /**XX **/
                /**   **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 1:
                /*******/
                /** X **/
                /** XX**/
                /**  X**/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 2:
                /*******/
                /**   **/
                /** XX**/
                /**XX **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 3:
                /*******/
                /**X  **/
                /**XX **/
                /** X **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            default:
                preconditionFailure()
            }
        case Z:
            switch rotation %% 4 {
            case 0:
                /*******/
                /**XX **/
                /** XX**/
                /**   **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 1:
                /*******/
                /**  X**/
                /** XX**/
                /** X **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 2:
                /*******/
                /**   **/
                /**XX **/
                /** XX**/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            case 3:
                /*******/
                /** X **/
                /**XX **/
                /**X  **/
                /*******/
                result = (Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0), Point(x:0, y:0))
            default:
                preconditionFailure()
            }
        }
        // TODO: TetriminoPoints -> Set<Point>, assert count == 4
        precondition(result.0 != result.1)
        precondition(result.0 != result.2)
        precondition(result.0 != result.3)
        precondition(result.1 != result.2)
        precondition(result.1 != result.3)
        precondition(result.2 != result.3)
        return result
    }
    
    func color() -> Color {
        switch self {
        case I:
            // Cyan
            return Color(argb: 0x4DBBEC)
        case O:
            // Yellow
            return Color(argb: 0xF4CC3C)
        case T:
            // Purple
            return Color(argb: 0x9B358A)
        case J:
            // Blue
            return Color(argb: 0x1824F2)
        case L:
            // Orange
            return Color(argb: 0xE6632F)
        case S:
            // Green
            return Color(argb: 0x6CF632)
        case Z:
            // Red
            return Color(argb: 0xE1272A)
        }
    }
}

struct Tetrimino {
    let shape: TetriminoShape

    private let rotation: Int

    init(shape: TetriminoShape) {
        self.init(shape: shape, rotation: 0)
    }
    
    private init(shape: TetriminoShape, rotation: Int) {
        self.shape = shape
        self.rotation = rotation % 4
    }
    
    var points: TetriminoPoints { get {
        return self.shape.points(self.rotation)
    }}

    func rotated(clockwise: Bool) -> Tetrimino {
        let newRotation = self.rotation + (clockwise ? 1 : -1)
        return Tetrimino(shape: self.shape, rotation: newRotation)
    }
}
