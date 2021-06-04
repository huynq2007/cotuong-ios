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
    func displayBoard(view controller: UIViewController) -> ()
    func getPieceAt(x: Int, y: Int) -> Piece?
}

class Board: BoardView, IBoard {
    
    final var AI = AIController(thinkingTime: 5)
    
    public static var MOVING_TURN: PieceColor = .RED
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    init() {
        super.init(frame: .zero)        
    }
    private var boardState: [[Piece?]] = Array.init(repeating: Array.init(repeating: nil, count: Config.X_SIZE), count: Config.Y_SIZE)
    
    func getPieceAt(x: Int, y: Int) -> Piece? {
        return boardState[y][x]
    }
    
    private func isValidMovement(of piece: Piece, to position: Point) -> Bool {
        return piece.validateMovement(to: position, status: boardState)
    }
    
    func makeMovement(piece: Piece, to position: Point) -> Bool {
        let fromPos = Point(x: piece.currentPosition!.x, y: piece.currentPosition!.y)
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
        
        //TODO: make engine movement
        self.AI.makeEngineMove(from: fromPos, to: position)
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
    
    func displayBoard(view controller: UIViewController) -> () {
        controller.view.addSubview(self)
        
        // display pieces
        for y in 0..<Config.Y_SIZE {
            for x in 0..<Config.X_SIZE {
                if let piece = boardState[y][x] {
                    let boardView = self as BoardView
                    let size = boardView.gridWidth
                    piece.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
                    piece.center = boardView.boardCoordinates[piece.currentPosition!.y][piece.currentPosition!.x]                    
                    controller.view.addSubview(piece)
                }
            }
        }
    }
}
