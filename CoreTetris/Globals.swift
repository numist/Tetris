public protocol Copyable {
    func copy() -> Self
}

enum Error : ErrorType {
    case InvalidParameter(Any, String)
}
