public typealias TetriminoPoints = Set<Point>

public func ==(left: Color, right: Color) -> Bool {
    return left.alpha == right.alpha && left.red == right.red && left.green == right.green && left.blue == right.blue
}

public struct Color {
    public let alpha: Double
    public let red: Double
    public let green: Double
    public let blue: Double
    public init(alpha: Int = 0, red: Int, green: Int, blue: Int) {
        precondition(alpha >= 0 && alpha < 256)
        precondition(red >= 0 && red < 256)
        precondition(green >= 0 && green < 256)
        precondition(blue >= 0 && blue < 256)
        
        self.alpha = Double(alpha) / 255
        self.red = Double(red) / 255
        self.green = Double(green) / 255
        self.blue = Double(blue) / 255
    }
    public init(argb: Int32) {
        let alpha = Int((argb & (0xFF << 24)) >> 24)
        let red   = Int((argb & (0xFF << 16)) >> 16)
        let green = Int((argb & (0xFF << 8))  >> 8)
        let blue  = Int((argb & (0xFF << 0))  >> 0)
        self.init(alpha: alpha, red: red, green: green, blue: blue)
    }
}

public enum TetriminoShape {
    case I, O, T, J, L, S, Z
    
    public static let allValues: [TetriminoShape] = [.I, .O, .T, .J, .L, .S, .Z]
    
    public func points(rotation: Int = 0) -> TetriminoPoints {
        var reducedRotation = rotation
        recoverableAssert(rotation >= 0 && rotation < 4) {
            reducedRotation = rotation %% 4
        }
        
        // Note: All ASCII art diagrams are using the lower left as (0,0)
        let result: TetriminoPoints
        switch self {
        case I:
            switch reducedRotation {
            case 0:
                // 3
                // 2XXXX
                // 1    
                // 0    
                // +0123
                result = [

                    Point(x:0, y:2), Point(x:1, y:2), Point(x:2, y:2), Point(x:3, y:2)


                ]
            case 1:
                // 3  X 
                // 2  X 
                // 1  X 
                // 0  X 
                // +0123
                result = [
                                                      Point(x:2, y:3),
                                                      Point(x:2, y:2),
                                                      Point(x:2, y:1),
                                                      Point(x:2, y:0)
                ]
            case 2:
                // 3    
                // 2    
                // 1XXXX
                // 0    
                // +0123
                result = [
                    
                    
                    Point(x:0, y:1), Point(x:1, y:1), Point(x:2, y:1), Point(x:3, y:1)
                
                ]
            case 3:
                // 3 X
                // 2 X  
                // 1 X  
                // 0 X  
                // +0123
                result = [
                                     Point(x:1, y:3),
                                     Point(x:1, y:2),
                                     Point(x:1, y:1),
                                     Point(x:1, y:0)
                ]
            default:
                preconditionFailure()
            }
        case O:
            /*2 XX */
            /*1 XX */
            /*0    */
            /**0123*/
            result = [
                                 Point(x:1, y:2), Point(x:2, y:2),
                                 Point(x:1, y:1), Point(x:2, y:1)
            ]
        case T:
            switch reducedRotation {
            case 0:
                // 2 X 
                // 1XXX
                // 0   
                // +012
                result = [
                                     Point(x:1, y:2),
                    Point(x:0, y:1), Point(x:1, y:1), Point(x:2, y:1)
                ]
            case 1:
                // 2 X 
                // 1 XX
                // 0 X 
                // +012
                result = [
                                     Point(x:1, y:2),
                                     Point(x:1, y:1), Point(x:2, y:1),
                                     Point(x:1, y:0)
                ]
            case 2:
                // 2   
                // 1XXX
                // 0 X 
                // +012
                result = [
                    
                    Point(x:0, y:1), Point(x:1, y:1), Point(x:2, y:1),
                                     Point(x:1, y:0)
                ]
            case 3:
                // 2 X
                // 1XX 
                // 0 X 
                // +012
                result = [
                                     Point(x:1, y:2),
                    Point(x:0, y:1), Point(x:1, y:1),
                                     Point(x:1, y:0)
                ]
            default:
                preconditionFailure()
            }
        case J:
            switch reducedRotation %% 4 {
            case 0:
                // 2X  
                // 1XXX
                // 0   
                // +012
                result = [
                    Point(x:0, y:2),
                    Point(x:0, y:1), Point(x:1, y:1), Point(x:2, y:1)
                    
                ]
            case 1:
                // 2 XX
                // 1 X 
                // 0 X 
                // +012
                result = [
                                     Point(x:1, y:2), Point(x:2, y:2),
                                     Point(x:1, y:1),
                                     Point(x:1, y:0)
                ]
            case 2:
                // 2   
                // 1XXX
                // 0  X
                // +012
                result = [
                    
                    Point(x:0, y:1), Point(x:1, y:1), Point(x:2, y:1),
                                                      Point(x:2, y:0)
                ]
            case 3:
                // 2 X
                // 1 X 
                // 0XX 
                // +012
                result = [
                                     Point(x:1, y:2),
                                     Point(x:1, y:1),
                    Point(x:0, y:0), Point(x:1, y:0)
                ]
            default:
                preconditionFailure()
            }
        case L:
            switch reducedRotation {
            case 0:
                // 2  X
                // 1XXX
                // 0   
                // +012
                result = [
                                                      Point(x:2, y:2),
                    Point(x:0, y:1), Point(x:1, y:1), Point(x:2, y:1)
                    
                ]
            case 1:
                // 2 X 
                // 1 X 
                // 0 XX
                // +012
                result = [
                                     Point(x:1, y:2),
                                     Point(x:1, y:1),
                                     Point(x:1, y:0), Point(x:2, y:0)
                ]
            case 2:
                // 2   
                // 1XXX
                // 0X  
                // +012
                result = [
                    
                    Point(x:0, y:1), Point(x:1, y:1), Point(x:2, y:1),
                    Point(x:0, y:0)
                ]
            case 3:
                // 2XX
                // 1 X 
                // 0 X 
                // +012
                result = [
                    Point(x:0, y:2), Point(x:1, y:2),
                                     Point(x:1, y:1),
                                     Point(x:1, y:0)
                ]
            default:
                preconditionFailure()
            }
        case S:
            switch reducedRotation {
            case 0:
                // 2 XX
                // 1XX 
                // 0   
                // +012
                result = [
                                     Point(x:1, y:2), Point(x:2, y:2),
                    Point(x:0, y:1), Point(x:1, y:1)

                ]
            case 1:
                // 2 X 
                // 1 XX
                // 0  X
                // +012
                result = [
                                     Point(x:1, y:2),
                                     Point(x:1, y:1), Point(x:2, y:1),
                                                      Point(x:2, y:0)
                ]
            case 2:
                // 2   
                // 1 XX
                // 0XX 
                // +012
                result = [
                    
                                     Point(x:1, y:1), Point(x:2, y:1),
                    Point(x:0, y:0), Point(x:1, y:0)
                ]
            case 3:
                // 2X
                // 1XX 
                // 0 X 
                // +012
                result = [
                    Point(x:0, y:2),
                    Point(x:0, y:1), Point(x:1, y:1),
                                     Point(x:1, y:0)
                ]
            default:
                preconditionFailure()
            }
        case Z:
            switch reducedRotation {
            case 0:
                // 2XX 
                // 1 XX
                // 0   
                // +012
                result = [
                    Point(x:0, y:2), Point(x:1, y:2),
                                     Point(x:1, y:1), Point(x:2, y:1)
                    
                ]
            case 1:
                // 2  X
                // 1 XX
                // 0 X 
                // +012
                result = [
                                                      Point(x:2, y:2),
                                     Point(x:1, y:1), Point(x:2, y:1),
                                     Point(x:1, y:0)
                ]
            case 2:
                // 2   
                // 1XX 
                // 0 XX
                // +012
                result = [

                    Point(x:0, y:1), Point(x:1, y:1),
                                     Point(x:1, y:0), Point(x:2, y:0)
                ]
            case 3:
                // 2 X
                // 1XX 
                // 0X  
                // +012
                result = [
                                     Point(x:1, y:2),
                    Point(x:0, y:1), Point(x:1, y:1),
                    Point(x:0, y:0)
                ]
            default:
                preconditionFailure()
            }
        }
        return result
    }
    
    public var color: Color { get {
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
        case .O:
            return self
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
        
        // FIXME: there's got to be a better way to do this
        switch self.shape {
        case .I:
            coordinates = [
                [false, false, false, false],
                [false, false, false, false],
                [false, false, false, false],
                [false, false, false, false]
            ]
        case .O:
            coordinates = [
                [false, false, false, false],
                [false, false, false, false],
                [false, false, false, false],
            ]
        case .T, .J, .L, .S, .Z:
            coordinates = [
                [false, false, false],
                [false, false, false],
                [false, false, false],
            ]
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

        // Rows, highest to lowest
        for i in (0..<coordinates.count).reverse() {
            // Columnes, lowest to highest
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
