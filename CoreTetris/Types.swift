public protocol Copyable {
    func copy() -> Self
}

enum Error : ErrorType {
    case InvalidParameter(Any, String)
}

func recoverableAssert(@autoclosure condition: () -> Bool, message: String? = nil, file: StaticString = __FILE__, line: UInt = __LINE__, recover: (Void) -> Void) {
    if !condition() {
        #if NDEBUG
            recover()
        #else
            if let message = message {
                assert(condition, message, file: file, line: line)
            } else {
                assert(condition, file: file, line: line)
            }
        #endif
    }
}
