//
//  Game.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation

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
