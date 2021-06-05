//
//  Game.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation
import UIKit

class Game {
    var board: IBoard?
    
    func newGame(fen: String, level: GameLevel) -> () {
        board = createBoardFromFenStr(fen: fen)
        (board as! Board).setAIEngine(AI: AIController(gameLevel: level, fen: fen))
    }
    
    func displayBoard(on view: UIViewController) -> () {
        board?.displayBoard(parent: view)
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
}
