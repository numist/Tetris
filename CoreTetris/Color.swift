public func ==(left: Color, right: Color) -> Bool {
    return left.alpha == right.alpha &&
           left.red == right.red &&
           left.green == right.green &&
           left.blue == right.blue
}

public struct Color {
    public let alpha: Double
    public let red: Double
    public let green: Double
    public let blue: Double
    
    public static var cyan: Color { get { return Color(argb: 0x4DBBEC) } }
    public static var yellow: Color { get { return Color(argb: 0xF4CC3C) } }
    public static var purple: Color { get { return Color(argb: 0x9B358A) } }
    public static var blue: Color { get { return Color(argb: 0x1824F2) } }
    public static var orange: Color { get { return Color(argb: 0xE6632F) } }
    public static var green: Color { get { return Color(argb: 0x6CF632) } }
    public static var red: Color { get { return Color(argb: 0xE1272A) } }
    
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
