//
//  Piece.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation

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
