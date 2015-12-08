public protocol TetriminoGenerator: Copyable {
    func next() -> TetriminoShape
}

// BPS's [Random Generator](http://tetris.wikia.com/wiki/Random_Generator)
final public class RandomGenerator<RNG where RNG:RandomNumberGenerator, RNG:Copyable>: TetriminoGenerator, Copyable {
    private var tetriminos: [TetriminoShape] = []
    private let generator: RNG
    
    public init(generator: RNG) {
        self.generator = generator
    }
    
    private init(tetriminos: [TetriminoShape], generator: RNG) {
        self.tetriminos = tetriminos
        self.generator = generator
    }
    
    public func copy() -> RandomGenerator {
        return RandomGenerator(tetriminos: self.tetriminos, generator: self.generator.copy())
    }
    
    private func generateBag() -> Void {
        var tetriminos = TetriminoShape.allValues
        let count = tetriminos.count
        for i in 0..<count {
            let element = tetriminos.removeAtIndex(i)
            // TODO: Modulo sucks, but there are seven tetriminos so it should shuffle pretty nicely?
            tetriminos.insert(element, atIndex: self.generator.next() % count)
        }
        
        self.tetriminos = tetriminos
    }
    
    public func next() -> TetriminoShape {
        if self.tetriminos.count == 0 {
            self.generateBag()
        }
        return self.tetriminos.removeFirst()
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
