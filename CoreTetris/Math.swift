// Remainder operator has same properties as modulo
infix operator %% { associativity left precedence 150 }
func %%(left: Int, right: Int) -> Int {
    return (((left % right) + right) % right)
}

extension Double {
    public var isIntegral: Bool { get {
        return floor(self) == self
    }}
}

public func ==(left: Int2D, right: Int2D) -> Bool {
    return left.x == right.x && left.y == right.y
}

public struct Int2D: Hashable {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    init(v: Double2D) {
        assert(v.x.isIntegral)
        assert(v.y.isIntegral)
        self.x = Int(v.x)
        self.y = Int(v.y)
    }
    
    public var hashValue: Int {
        return self.x ^ self.y << 16
    }
}

public func ==(left: Double2D, right: Double2D) -> Bool {
    return left.x == right.x && left.y == right.y
}

public func -(left: Double2D, right: Double2D) -> Double2D {
    return Double2D(x: left.x - right.x, y: left.y - right.y)
}

public func +(left: Double2D, right: Double2D) -> Double2D {
    return Double2D(x: left.x + right.x, y: left.y + right.y)
}

public struct Double2D {
    let x: Double
    let y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    init(v: Int2D) {
        self.x = Double(v.x)
        self.y = Double(v.y)
    }
}
