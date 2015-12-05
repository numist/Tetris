// Remainder operator has same properties as modulo
infix operator %% { associativity left precedence 150 }
func %%(left: Int, right: Int) -> Int {
    return (((left % right) + right) % right)
}

public func ==(left: Point, right: Point) -> Bool {
    return left.x == right.x && left.y == right.y
}

public struct Point: Hashable {
    let x: Int
    let y: Int
    
    public var hashValue: Int {
        return self.x ^ self.y << 16
    }
}
