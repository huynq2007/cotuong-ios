//
//  Board.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation
import UIKit

protocol IBoard {
    func makeMovement(piece: Piece, to position: Point) -> Bool
    func addPiece(piece: Piece, to position: Point?) -> Bool
    func displayBoard(parent view: UIViewController) -> ()
    func getPieceAt(x: Int, y: Int) -> Piece?
    func foreachPiece(action: (_ x: Int, _ y: Int)->())
}

class Board: BoardView, IBoard {
    
    final var AI: AIController?
    
    public static var MOVING_TURN: PieceColor = .RED
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    deinit {
        AI?.quitEngine()
    }
    init() {
        super.init(frame: .zero)        
    }
    func setAIEngine(AI: AIController) {
        self.AI = AI
    }
    private var boardState: [[Piece?]] = Array.init(repeating: Array.init(repeating: nil, count: Config.X_SIZE), count: Config.Y_SIZE)
    
    func getPieceAt(x: Int, y: Int) -> Piece? {
        return boardState[y][x]
    }
    
    private func isValidMovement(of piece: Piece, to position: Point) -> Bool {
        if let _ = self.AI {
            return self.AI!.validateMove(from: piece.currentPosition!, to: position)
        }
        return false
    }
    
    func makeMovement(piece: Piece, to position: Point) -> Bool {
        
        let _from = Point(x: piece.currentPosition!.x, y: piece.currentPosition!.y)
        let _to = Point(x: position.x, y: position.y)
        let _targetPiece = boardState[position.y][position.x]
        
        if !isValidMovement(of: piece, to: position) {
            return false
        }
        if let _ = _targetPiece {
            if !removePiece(piece: _targetPiece!) {
                return false
            }
        }
        if !removePiece(piece: piece) {
            return false
        }
        if !addPiece(piece: piece, to: position) {
            return false
        }
        
        // Change Turn
        if Board.MOVING_TURN == .RED {
            Board.MOVING_TURN = .BLACK
        }else {
            Board.MOVING_TURN = .RED
        }
        
        // update engine state
        let _ = self.AI?.makeEngineMove(from: _from, to: _to)
        
        // update GUI
        UIView.animate(withDuration: 0.4, delay: 0, options: [AnimationOptions.transitionCrossDissolve], animations: {
            piece.center = piece.currentPosition!.toScreenCoordinate()
            self.superview?.bringSubviewToFront(piece)
        }) { finished in
            
            if (self.AI!.validateMateStatus()) {
                if Board.MOVING_TURN == .BLACK {
                    MusicHelper.instancePlayer.playSound(for: "win")
                } else {
                    MusicHelper.instancePlayer.playSound(for: "loss")
                }
                return
            } else if (self.AI!.validateCheckingStatus()) {
                MusicHelper.instancePlayer.playSound(for: "check2")
            } else if (self.AI!.validateDrawStatus()) {
                MusicHelper.instancePlayer.playSound(for: "draw")
            } else {
                MusicHelper.instancePlayer.playSound(for: "move")
            }
            
            piece.isSelected = false
            _targetPiece?.removeFromSuperview()
            
            // wait for AI move
            self.AIMove()
        }
        
        #if DEBUG
        displayBoardString()
        #endif
        
        return true
    }
    
    func AIMove() {
        if Board.MOVING_TURN == .BLACK {
            guard let (from, to) = self.AI?.tryThink() else { return }
            if let piece = self.getPieceAt(x: from.x, y: from.y) {
                let _ = self.makeMovement(piece: piece, to: to)
            }
        }
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
    
    func displayBoard(parent view: UIViewController) -> () {
        self.frame = view.view.frame
        view.view.addSubview(self)
        
        // display pieces
        foreachPiece(action: { (x, y) in
            if let piece = boardState[y][x] {
                piece.frame = CGRect(origin: .zero, size: CGSize(width: Config.PIECE_SIZE, height: Config.PIECE_SIZE))
                piece.center = piece.currentPosition!.toScreenCoordinate()
                view.view.addSubview(piece)
            }
        })
    }
    
    func displayBoardString() -> () {
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

extension Board {
    func foreachPiece(action: (_ x: Int, _ y: Int)->()) {
        for y in 0..<Config.Y_SIZE {
            for x in 0..<Config.X_SIZE {
                action(x, y)
            }
        }
    }
}
