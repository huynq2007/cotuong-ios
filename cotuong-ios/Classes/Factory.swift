//
//  Factory.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation

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
