enum PieceColor: String {
    case RED = "\u{001B}[0;31m" , BLACK = "\u{001B}[0;34m", NONE = "\u{001B}[0;0m"
}

struct Config {
    static let X_SIZE = 9
    static let Y_SIZE = 10
}

enum PieceType: String {
    case RROOK="R"
    case BROOK="r"
    case RHORSE="H"
    case BHORSE="h"
    case RELEPHANT="E"
    case BELEPHANT="e"
    case RADVISOR="A"
    case BADVISOR="a"
    case RKING="K"
    case BKING="k"
    case RCANON="C"
    case BCANON="c"
    case RPAWN="P"
    case BPAWN="p"
}

struct Point {
    // (0, 0) will be at top-left
    var x = 0, y = 0
}

protocol IBoard {
    func makeMovement(piece: Piece, to position: Point) -> Bool
}

class Board: IBoard {
    var boardState: [[Piece?]] = Array.init(repeating: Array.init(repeating: nil, count: Config.X_SIZE), count: Config.Y_SIZE)
    
    subscript (x: Int, y: Int) -> Piece? {
        get {
            return boardState[y][x]
        }
    }
    
    final func isValidMovement(piece: Piece, to position: Point) -> Bool {
        return piece.validateMovement(to: position, status: boardState)
    }
    
    final func makeMovement(piece: Piece, to position: Point) -> Bool {
        if !isValidMovement(piece: piece, to: position) {
            return false
        }

        if let targetPiece = boardState[position.y][position.x] {
            let _ = removePiece(piece: targetPiece)
        }
        let _ = addPiece(piece: piece)
        
        return true
    }
    
    final func addPiece(piece: Piece) -> Bool {
        guard let x = piece.currentPosition?.x else {
            return false
        }
        guard let y = piece.currentPosition?.y else {
            return false
        }
        if (!removePiece(piece: piece)) {
            return false
        }
        
        boardState[y][x] = piece
        
        return true
    }
    
    final func removePiece(piece: Piece) -> Bool {
        guard let x = piece.currentPosition?.x else {
            return false
        }
        guard let y = piece.currentPosition?.y else {
            return false
        }
        
        boardState[y][x] = nil
        
        return true
    }
    
    final func displayBoard() {
        for y in 0..<Config.Y_SIZE {
            var line: String = ""
            for x in 0..<Config.X_SIZE {
                if let piece = boardState[y][x] {
                    line += String(describing: piece)
                } else {
                    line += " [-,-,-] "
                }
            }
            print(line)
        }
    }
}

class Piece: CustomStringConvertible {
    var board: IBoard?
    var currentPosition: Point?
    var color: PieceColor?
    var fenChar: Character {
        get {
            return Array(String(describing: type(of: self)))[0]
        }
    }
    
    var description: String { return "\(color!.rawValue) [\(fenChar),\(String(describing: currentPosition!.x)),\(String(describing: currentPosition!.y))] \(PieceColor.NONE.rawValue)"}
    
    init (position: Point, color: PieceColor) {
        self.currentPosition = Point(x: position.x, y: position.y)
        self.color = color
    }
    
    init () {
    }
        
    final func moveTo(to position: Point) {
        let _ = board?.makeMovement(piece: self, to: position)
    }
    
    func validateMovement(to position: Point, status board: [[Piece?]]?) -> Bool {
        fatalError("not implemented yet!")
    }
}

class Advisor : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]?) -> Bool {
        //TODO:
        return false
    }
}

class Cannon : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]?) -> Bool {
        //TODO:
        return false
    }
}

class Elephant : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]?) -> Bool {
        //TODO:
        return false
    }
}

class Horse : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]?) -> Bool {
        //TODO:
        return false
    }
}

class King : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]?) -> Bool {
        //TODO:
        return false
    }
}

class Pawn : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]?) -> Bool {
        //TODO:
        return false
    }
}

class Rook : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]?) -> Bool {
        //TODO:
        return false
    }
}

class Factory {
    func createInstance(piece type: PieceType, at position: Point) -> Piece {
        let piece: Piece
        
        switch type {
        case .RROOK:
            piece = Rook(position: position, color: .RED)
        case .BROOK:
            piece = Rook(position: position, color: .BLACK)
        case .RHORSE:
            piece = Horse(position: position, color: .RED)
        case .BHORSE:
            piece = Horse(position: position, color: .BLACK)
        case .RELEPHANT:
            piece = Elephant(position: position, color: .RED)
        case .BELEPHANT:
            piece = Elephant(position: position, color: .BLACK)
        case .RADVISOR:
            piece = Advisor(position: position, color: .RED)
        case .BADVISOR:
            piece = Advisor(position: position, color: .BLACK)
        case .RKING:
            piece = King(position: position, color: .RED)
        case .BKING:
            piece = King(position: position, color: .BLACK)
        case .RCANON:
            piece = Cannon(position: position, color: .RED)
        case .BCANON:
            piece = Cannon(position: position, color: .BLACK)
        case .RPAWN:
            piece = Piece(position: position, color: .RED)
        case .BPAWN:
            piece = Piece(position: position, color: .BLACK)
        }
        return piece
    }
}

class Game {
    var red_player: String = "hoge"
    var black_player: String = "foo"
    var turn_player: PieceColor = .RED
    var board: Board?
    
    struct Action: Equatable {
        var name: String = "name"
        var description: String = "description"
        var execution: () -> () = {()->() in
            // do nothing
        }
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.name == rhs.name
        }
    }
    
    final func newGame() {
        board = createDefaultBoard()
    }
    final func displayBoard() -> () {
        board?.displayBoard()
    }
    
    func createDefaultBoard() -> Board {
        let board: Board = Board()
        let factory: Factory = Factory()
        
        let rrook = factory.createInstance(piece: .RROOK, at: Point(x: 1, y: 1))
        let _ = board.addPiece(piece: rrook)
        
        let brook = factory.createInstance(piece: .BROOK, at: Point(x: 2, y: 2))
        let _ = board.addPiece(piece: brook)
        
        return board
    }
    func createBoardFromFenStr(fen: String) -> Board? {
        //TODO:
        return nil
    }
    
    final func start() {
        let actions = [
            Action(name: "1", description: "new game", execution: newGame),
            Action(name: "2", description: "display board", execution: displayBoard),
            Action(name: "3", description: "quit game")
        ]
        
        var selectedOption: Action?
        while selectedOption != actions.last {
            for item in actions {
                print("\(item.name)- \(item.description)")
            }
            print("=========")
            let input: String! = readLine()
            selectedOption = actions.first(where: {$0.name == input})
            selectedOption?.execution()
        }
    }
}

let game = Game()
game.start()
