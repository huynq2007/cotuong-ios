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
    
    override var description: String { return "\(pieceColor!.rawValue) [\(fenChar),\(String(describing: currentPosition!.x)),\(String(describing: currentPosition!.y))] \(PieceColor.CLEAR.rawValue)"}
    
    
    final func moveTo(to position: Point) -> Bool {
        let result = board!.makeMovement(piece: self, to: position)
        
        if !result {
            MusicHelper.sharedHelper.playSound(for: "illegal")
            return false
        }
        
        // update GUI
        let boardView = (board as? BoardView)
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { () in
            self.center = (boardView?.boardCoordinates[position.y][position.x])!
        }) { finished in
            MusicHelper.sharedHelper.playSound(for: "move")
            self.isSelected = false
            
            // Change Turn
            if Board.MOVING_TURN == .RED {
                Board.MOVING_TURN = .BLACK
            }else {
                Board.MOVING_TURN = .RED
            }
            
            if Board.MOVING_TURN == .BLACK {
                //TODO: AI MOVE
                let baord  = (self.board as! Board)                
                guard let (from, to) = baord.AI.tryThink() else { return }
                let _from = Point(x: from.x, y: from.y)
                let _to = Point(x: to.x, y: to.y)
                
                if let piece = baord.getPieceAt(x: _from.x, y: _from.y) {
                    piece.moveTo(to: _to)
                }
            }
        }
        
        return result
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
