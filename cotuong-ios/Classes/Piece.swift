//
//  Piece.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation
import UIKit

protocol IPiece {
    func attachToBoard(to board: IBoard)
}

class Piece: PieceView, IPiece {
    private var board: IBoard?
    var currentPosition: Point?
    var pieceColor: PieceColor?
    var fenChar: Character {
        get {
            return String(describing: type(of: self))[0]
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init (at position: Point, color: PieceColor) {
        super.init(frame: .zero)
        self.currentPosition = Point(x: position.x, y: position.y)
        self.pieceColor = color
        self.setBackgroundImage(UIImage(named: self.getFace()), for: .normal)
        self.setImage(UIImage(named: "cursor"), for: .selected)
    }
    
//    override var description: String { return "\(pieceColor!.rawValue) [\(fenChar),\(String(describing: currentPosition!.x)),\(String(describing: currentPosition!.y))] \(PieceColor.CLEAR.rawValue)"}
    override var description: String { return " [\(fenChar),\(String(describing: currentPosition!.x)),\(String(describing: currentPosition!.y))] "}
    
    
    final func moveTo(to position: Point) -> Bool {
        return board!.makeMovement(piece: self, to: position)
    }
    
    func getFace() -> String {
        fatalError("not implemented yet!")
    }
    
    func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
        fatalError("not implemented yet!")
    }
    
    final func attachToBoard(to board: IBoard) -> () {
        self.board = board
        let _ = board.addPiece(piece: self, to: nil)
    }
}
