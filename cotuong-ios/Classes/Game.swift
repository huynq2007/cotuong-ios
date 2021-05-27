//
//  Game.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation

enum PieceColor: String {
    case RED = "\u{001B}[0;31m" , BLACK = "\u{001B}[0;34m", CLEAR = "\u{001B}[0;0m"
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

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

struct Point {
    // (0, 0) will be at top-left
    var x = 0, y = 0
}

protocol IBoard {
    func makeMovement(piece: Piece, to position: Point) -> Bool
    func addPiece(piece: Piece, to position: Point?) -> Bool
    func displayBoard() -> ()
    func getPieceAt(x: Int, y: Int) -> Piece?
}

class Board: IBoard {
    private var boardState: [[Piece?]] = Array.init(repeating: Array.init(repeating: nil, count: Config.X_SIZE), count: Config.Y_SIZE)
    
    func getPieceAt(x: Int, y: Int) -> Piece? {
        return boardState[y][x]
    }
    
    private func isValidMovement(of piece: Piece, to position: Point) -> Bool {
        return piece.validateMovement(to: position, status: boardState)
    }
    
    func makeMovement(piece: Piece, to position: Point) -> Bool {
        if !isValidMovement(of: piece, to: position) {
            return false
        }
        if let targetPiece = boardState[position.y][position.x] {
            if !removePiece(piece: targetPiece) {
                return false
            }
        }
        if !removePiece(piece: piece) {
            return false
        }
        if !addPiece(piece: piece, to: position) {
            return false
        }
        return true
    }
    
    func addPiece(piece: Piece, to position: Point? = nil) -> Bool {
        if position != nil {
            piece.currentPosition = Point(x: position!.x, y: position!.y)
        }
        boardState[piece.currentPosition!.y][piece.currentPosition!.x] = piece
        return true
    }
    
    private func removePiece(piece: Piece) -> Bool {
        guard let x = piece.currentPosition?.x, let y = piece.currentPosition?.y else {
            return false
        }
        boardState[y][x] = nil
        return true
    }
    
    func displayBoard() -> () {
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

protocol IPiece {
    func attachToBoard(to board: IBoard)
}

class Piece: CustomStringConvertible, IPiece {
    private var board: IBoard?
    var currentPosition: Point?
    var color: PieceColor?
    var fenChar: Character {
        get {
            return String(describing: type(of: self))[0]
        }
    }
    
    var description: String { return "\(color!.rawValue) [\(fenChar),\(String(describing: currentPosition!.x)),\(String(describing: currentPosition!.y))] \(PieceColor.CLEAR.rawValue)"}
    
    init (at position: Point, color: PieceColor) {
        self.currentPosition = Point(x: position.x, y: position.y)
        self.color = color
    }
    
    final func moveTo(to position: Point) -> Bool {
        return board!.makeMovement(piece: self, to: position)
    }
    
    func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
        fatalError("not implemented yet!")
    }
    
    final func attachToBoard(to board: IBoard) -> () {
        self.board = board
        let _ = board.addPiece(piece: self, to: nil)
    }
}

class Advisor : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
        let deltaX = abs(currentPosition!.x - position.x)
        let deltaY = abs(currentPosition!.y - position.y)
        if (deltaX != 1 || deltaY != 1) {
            return false
        }
        if (position.x < 3 || position.x > 5) {
            return false
        }
        if (color == PieceColor.BLACK && position.y > 2) {
            return false
        }
        if (color == PieceColor.RED && position.y < 7) {
            return false
        }
        return true
    }
}

class Cannon : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
        let deltaX = abs(currentPosition!.x - position.x)
        let deltaY = abs(currentPosition!.y - position.y)
        if(deltaX > 0 && deltaY > 0) {
            return false
        }
        var blockCount = 0
        if (currentPosition!.x == position.x) {
            let minY = min(currentPosition!.y, position.y)
            let maxY = max(currentPosition!.y, position.y)
            for step in minY + 1..<maxY {
                if let _ = board[step][currentPosition!.x] {
                    blockCount += 1
                }
            }
        } else if (currentPosition!.y == position.y) {
            let minX = min(currentPosition!.x, position.x)
            let maxX = max(currentPosition!.x, position.x)
            for step in minX + 1..<maxX {
                if let _ = board[currentPosition!.y][step] {
                    blockCount += 1
                }
            }
        }
        if let piece = board[position.y][position.x] {
            if (piece.color != self.color) {
                if blockCount > 1 {
                    return false
                }
            }else {
                return false
            }
        }else {
            if blockCount > 0 {
                return false
            }
        }
        
        return true
    }
}

class Elephant : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
        let deltaX = abs(currentPosition!.x - position.x)
        let deltaY = abs(currentPosition!.y - position.y)
        if (deltaX != 2 || deltaY != 2) {
            return false
        }
        if (color == PieceColor.BLACK && position.y > 4) {
            return false
        }
        if (color == PieceColor.RED && position.y < 5) {
            return false
        }
        return true
    }
}

class Horse : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
        let deltaX = abs(currentPosition!.x - position.x)
        let deltaY = abs(currentPosition!.y - position.y)
        if (deltaX == 0 || deltaY == 0 || deltaX + deltaY != 3) {
            return false
        }
        if (deltaX == 2) {
            if let _ = board[position.y][(currentPosition!.x + position.x)/2] {
                return false
            }
        }
        if (deltaY == 2) {
            if let _ = board[(currentPosition!.y + position.y)/2][position.x] {
                return false
            }
        }
        return true
    }
}

class King : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
        let deltaX = abs(currentPosition!.x - position.x)
        let deltaY = abs(currentPosition!.y - position.y)
        if (deltaY + deltaX != 1) {
            return false
        }
        if (position.x < 3 || position.x > 5) {
            return false
        }
        if (color == PieceColor.BLACK && position.y > 2) {
            return false
        }
        if (color == PieceColor.RED && position.y < 7) {
            return false
        }
        return true
    }
}

class Pawn : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
        let deltaX = abs(currentPosition!.x - position.x)
        let deltaY = abs(currentPosition!.y - position.y)
        if(deltaX + deltaY >= 2) {
            return false
        }
        if (color == PieceColor.RED) {
            if position.y > currentPosition!.y {
                return false
            }
            if currentPosition!.y >= 5 && deltaX == 1 {
                return false
            }
        }
        if (color == PieceColor.BLACK) {
            if currentPosition!.y > position.y {
                return false
            }
            if currentPosition!.y < 5 && deltaX == 1 {
                return false
            }
        }
        return true
    }
}

class Rook : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
        let deltaX = abs(currentPosition!.x - position.x)
        let deltaY = abs(currentPosition!.y - position.y)
        if(deltaX > 0 && deltaY > 0) {
            return false
        }
        
        if (currentPosition!.x == position.x) {
            for step in currentPosition!.y + 1..<position.y {
                if let _ = board[step][currentPosition!.x] {
                    return false
                }
            }
        }else if (currentPosition!.y == position.y) {
            for step in currentPosition!.x + 1..<position.x {
                if let _ = board[step][currentPosition!.x] {
                    return false
                }
            }
        }
        
        return true
    }
}

class Factory {
    private var board: IBoard
    
    init (board: IBoard) {
        self.board = board
    }
    
    func createInstance(piece type: PieceType, at position: Point) -> () {
        let piece: Piece
        
        switch type {
        case .RROOK:
            piece = Rook(at: position, color: .RED)
        case .BROOK:
            piece = Rook(at: position, color: .BLACK)
        case .RHORSE:
            piece = Horse(at: position, color: .RED)
        case .BHORSE:
            piece = Horse(at: position, color: .BLACK)
        case .RELEPHANT:
            piece = Elephant(at: position, color: .RED)
        case .BELEPHANT:
            piece = Elephant(at: position, color: .BLACK)
        case .RADVISOR:
            piece = Advisor(at: position, color: .RED)
        case .BADVISOR:
            piece = Advisor(at: position, color: .BLACK)
        case .RKING:
            piece = King(at: position, color: .RED)
        case .BKING:
            piece = King(at: position, color: .BLACK)
        case .RCANON:
            piece = Cannon(at: position, color: .RED)
        case .BCANON:
            piece = Cannon(at: position, color: .BLACK)
        case .RPAWN:
            piece = Piece(at: position, color: .RED)
        case .BPAWN:
            piece = Piece(at: position, color: .BLACK)
        }
        piece.attachToBoard(to: self.board)
    }
}

class Game {
    var red_player: String = "hoge"
    var black_player: String = "foo"
    var turn_player: PieceColor = .RED
    var board: IBoard?
    
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
    
    func newGame() -> () {
        let fen: String = "rheakaehr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RHEAKAEHR w - - 0 1"
        board = createBoardFromFenStr(fen: fen)
    }
    func displayBoard() -> () {
        board?.displayBoard()
    }
    
    func makeMovement() -> () {
        print("make a move from (x1,y1) to (x2,y2):")
        let input: String? = readLine()
        guard let position = input?.split(separator: " ") else {
            print("invalid input!")
            return
        }
        if position.count != 4 {
            print("invalid input!")
            return
        }
        guard let x1 = Int(position[0]), let y1 = Int(position[1]), let x2 = Int(position[2]), let y2 = Int(position[3]) else {
            print("invalid input!")
            return
        }
        
        guard let selectedPiece = board?.getPieceAt(x: x1, y: y1) else {
            print("invalid input!")
            return
        }
        
        if !selectedPiece.moveTo(to: Point(x: x2, y: y2)) {
            print("cannot move!")
            return
        }
    }
    
    func createBoardFromFenStr(fen: String) -> IBoard {
        let board: IBoard = Board() as IBoard
        let factory: Factory = Factory(board: board)
        
        let RANK_TOP = 0
        let RANK_BOTTOM = 9
        let FILE_LEFT = 0
        let FILE_RIGHT = 8
        
        var x = RANK_TOP, y = FILE_LEFT
        var index = 0
        
        if index == fen.count {
            return board
        }
        
        var c = fen[index]
        while c != " " {
            if c == "/" {
                x = FILE_LEFT
                y += 1
                if y > RANK_BOTTOM {
                    break
                }
            } else if c >= "1" && c <= "9" {
                let range = c.unicodeScalars.first!.value - "0".unicodeScalars.first!.value
                for _ in 0..<range {
                    if x >= FILE_RIGHT {
                        break
                    }
                    x += 1
                }
            } else if ((c >= "A" && c <= "Z")||(c >= "a" && c <= "z")) {
                if x <= FILE_RIGHT {
                    guard let type = PieceType(rawValue: String(c)) else {
                        fatalError("invalid fen string!")
                    }
                    factory.createInstance(piece: type, at: Point(x: x, y: y))
                    x += 1
                }
            }
            index += 1
            if (index == fen.count) {
                return board
            }
            c = fen[index]
        }
        
        return board
    }
    
    func start() -> () {
        let actions = [
            Action(name: "1", description: "new game", execution: newGame),
            Action(name: "2", description: "display board", execution: displayBoard),
            Action(name: "3", description: "make movement", execution: makeMovement),
            Action(name: "4", description: "quit game")
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
