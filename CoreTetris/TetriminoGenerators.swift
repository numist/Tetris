import Darwin

public protocol TetriminoGenerator {
    func next() -> Tetrimino
}

extension Array {
    func randomized() -> [Element] {
        var result = self
        let count = result.count
        for i in 0..<count {
            let element = result.removeAtIndex(i)
            result.insert(element, atIndex: Int(arc4random_uniform(UInt32(count))))
        }
        return result
    }
}

// BPS's [Random Generator](http://tetris.wikia.com/wiki/Random_Generator)
public class RandomGenerator: TetriminoGenerator {
    private var tetriminos: [TetriminoType] = []
    
    private func generateBag() -> Void {
        self.tetriminos = TetriminoType.allValues.randomized()
    }
    
    public func next() -> Tetrimino {
        if self.tetriminos.count == 0 {
            self.generateBag()
        }
        return Tetrimino(shape: self.tetriminos.removeFirst())
    }
}


// never deals an S, Z or O as the first piece, to avoid a forced overhang
// try using rand(0..<7) up to 4 times to generate a piece that is not in the most recent 4 produced
class GrandMasterOneGenerator {}

// never deals an S, Z or O as the first piece, to avoid a forced overhang
// try using rand(0..<7) up to 6 times to generate a piece that is not in the most recent 4 produced
// the history begins with a Z,Z,S,S sequence. However, as the first piece of the game overwrites the first Z rather than pushing off the last S, this is effectively a Z,S,S,Z or Z,S,Z,S sequence
class GrandMasterGenerator {}

// deals a bag of 7 randomized tetrominoes
// never deals an S, Z or O as the first piece
class GrandMasterAceGenerator {}

// http://tetrisconcept.net/threads/randomizer-theory.512/page-9#post-55478
class TerrorInstinctGenerator {}
