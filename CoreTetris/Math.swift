import Foundation

// Remainder operator has same properties as modulo
infix operator %% { associativity left precedence 150 }
func %%(left: Int, right: Int) -> Int {
    return (((left % right) + right) % right)
}

extension Double {
    var isIntegral: Bool { get {
        return floor(self) == self
    }}
}

public func ==(left: Int2D, right: Int2D) -> Bool {
    return left.x == right.x && left.y == right.y
}

public func -(left: Int2D, right: Int2D) -> Int2D {
    return Int2D(x: left.x - right.x, y: left.y - right.y)
}

public func +(left: Int2D, right: Int2D) -> Int2D {
    return Int2D(x: left.x + right.x, y: left.y + right.y)
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

public protocol RandomNumberGenerator {
    func next() -> Int
}

final public class FibonacciLinearFeedbackShiftRegister16: Copyable, RandomNumberGenerator {
    private var register: Int
    private let taps: [Int]
    
    public convenience init() {
        do {
            try self.init(seed: 0x8988, taps: [1,9])
        } catch _ {}
    }
    
    public init(seed: UInt16, taps: [Int]) throws {
        // All stored properties of a class instance must be initialized before throwing from an initializer
        // This is a bug in Swift: https://devforums.apple.com/thread/251388?start=0&tstart=0#1062922
        self.taps = taps
        self.register = Int(seed)
        if seed == 0 {
            throw Error.InvalidParameter(seed, "seed parameter must not be zero")
        }
        try taps.forEach { tap in
            if 0 > tap || tap >= 16 {
                throw Error.InvalidParameter(taps, "taps parameter must only contain values in the range 0..<16")
            }
        }
        if taps.count < 2 {
            throw Error.InvalidParameter(taps, "taps parameter must contain at least two values")
        }
//        self.taps = taps
//        self.register = seed
    }
    
    private func _tap(offset: Int) -> Int {
        return (self.register >> offset) & 1
    }
    
    public func next() -> Int {
        self.register = (self.register >> 1) | (self.taps.map({ self._tap($0) }).reduce(0, combine: { $0 ^ $1 }) << 15)
        return Int(self.register)
    }
    
    public func copy() -> FibonacciLinearFeedbackShiftRegister16 {
        // This little dance is because the initializer can fail, but not when making a copy (self must be a valid object)
        guard let result = try? FibonacciLinearFeedbackShiftRegister16(seed:UInt16(self.register), taps: self.taps) else {
            preconditionFailure()
        }
        return result
    }
}
