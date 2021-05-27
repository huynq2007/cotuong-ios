//
//  Board.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation

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
