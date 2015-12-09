import Foundation
import Darwin.ncurses
import Darwin

private extension Int32 {
    static let W: Int32 = 119  // ⇟
    static let A: Int32 = 97   // ←
    static let S: Int32 = 115  // ↓
    static let D: Int32 = 100  // →
    static let Q: Int32 = 113  // ⟲
    static let E: Int32 = 101  // ⟳
    static let Esc: Int32 = 27 // Quit
}

setlocale(LC_ALL, "")
initscr()                   // Init window. Must be first
noecho()
curs_set(0)                 // Set cursor to invisible
//intrflush(stdscr, true)     // Prevent flush
//keypad(stdscr, true)        // Enable function and arrow keys

let seed = UInt16(arc4random_uniform(UInt32(UINT16_MAX))) + 1
guard let generator = try? RandomGenerator(generator: FibonacciLinearFeedbackShiftRegister16(seed: seed)) else { preconditionFailure() }
var state = GameState(generator: generator)

let draw = {
    move(0,0)
    addstr(state.description)
    refresh()
}

var runloop = true
draw()
repeat {
    let command = getch()
    switch command {
    case Int32.W:
        state = state.withHardDrop()
        draw()
    case Int32.A:
        state = state.movedLeft()
        draw()
    case Int32.S:
        state = state.movedDown()
        draw()
    case Int32.D:
        state = state.movedRight()
        draw()
    case Int32.Q:
        state = state.rotatedCCW()
        draw()
    case Int32.E:
        state = state.rotatedCW()
        draw()
    case Int32.Esc:
        runloop = false
    default: ()
    }
} while runloop

endwin()
