//
//  Board.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation
import UIKit

protocol BoardMovingHandler {
    func onBoardMovingComplete()
}

protocol IBoard {
    func makeMovement(piece: Piece, to position: Point) -> MoveResult
    func addPiece(piece: Piece, to position: Point?) -> Bool
    func displayBoard(parent view: UIViewController) -> ()
    func getPieceAt(x: Int, y: Int) -> Piece?
    func foreachPiece(action: (_ x: Int, _ y: Int)->())
}

class Board: BoardView, IBoard {
    
    final var AI: AIController?
    private var parentController: UIViewController?
    var boardMovingHandler: BoardMovingHandler?
    
    private var _movingTurn: PieceColor = .RED
    var MOVING_TURN: PieceColor {
        get {
            return _movingTurn
        }
        set (turn) {
            _movingTurn = turn
            updateMovingStatus()
        }
    }
    
    var IS_GAME_OVER: Bool = false
    
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
    
    func makeMovement(piece: Piece, to position: Point) -> MoveResult {
        
        let _from = Point(x: piece.currentPosition!.x, y: piece.currentPosition!.y)
        let _to = Point(x: position.x, y: position.y)
        let _targetPiece = boardState[position.y][position.x]
        
        if !isValidMovement(of: piece, to: position) {
            return MoveResult.MOVE_INVALID
        }
        if let _ = _targetPiece {
            if !removePiece(piece: _targetPiece!) {
                return MoveResult.MOVE_INVALID
            }
        }
        if !removePiece(piece: piece) {
            return MoveResult.MOVE_INVALID
        }
        if !addPiece(piece: piece, to: position) {
            return MoveResult.MOVE_INVALID
        }
        
        // update GUI
        UIView.animate(withDuration: 0.4, delay: 0, options: [AnimationOptions.transitionCrossDissolve], animations: {
            piece.center = piece.currentPosition!.toScreenCoordinate()
            self.superview?.bringSubviewToFront(piece)
        }) { finished in
            
            piece.isSelected = false
            _targetPiece?.removeFromSuperview()
            
            self.boardMovingHandler?.onBoardMovingComplete()
        }
        
        // update engine state
        let _ = self.AI?.makeEngineMove(from: _from, to: _to)
        
        // Change Turn
        if self.MOVING_TURN == .RED {
            self.MOVING_TURN = .BLACK
        }else {
            self.MOVING_TURN = .RED
        }
        
        if (self.AI!.validateMateStatus()) {
            self.IS_GAME_OVER = true
            return MoveResult.MOVE_MATE
        }
        
        if (self.AI!.validateCheckingStatus()) {
            return MoveResult.MOVE_CHECK
        }
        
        if (self.AI!.validateDrawStatus()) {
            self.IS_GAME_OVER = true
            return MoveResult.MOVE_DRAW
        }
        
        return MoveResult.MOVE_NORMAL
    }
    
    func AIMove() -> MoveResult {
        if self.MOVING_TURN == .BLACK {
            guard let (from, to) = self.AI?.tryThink() else { return MoveResult.MOVE_NONE }
            if let piece = self.getPieceAt(x: from.x, y: from.y) {
                return self.makeMovement(piece: piece, to: to)
            }
        }
        return MoveResult.MOVE_NONE
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
        self.parentController = view
        self.frame = view.view.frame
        view.view.addSubview(self)
        
        // positioning all pieces
        foreachPiece(action: { (x, y) in
            if let piece = boardState[y][x] {
                piece.frame = CGRect(origin: .zero, size: CGSize(width: Config.PIECE_SIZE, height: Config.PIECE_SIZE))
                piece.center = piece.currentPosition!.toScreenCoordinate()                
                piece.isHidden = true
                view.view.addSubview(piece)
            }
        })
    }
}

