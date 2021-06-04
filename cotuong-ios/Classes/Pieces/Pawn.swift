//
//  Pawn.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation

class Pawn : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
//        let deltaX = abs(currentPosition!.x - position.x)
//        let deltaY = abs(currentPosition!.y - position.y)
//        if(deltaX + deltaY >= 2) {
//            return false
//        }
//        if (pieceColor == PieceColor.RED) {
//            if position.y > currentPosition!.y {
//                return false
//            }
//            if currentPosition!.y >= 5 && deltaX == 1 {
//                return false
//            }
//        }
//        if (pieceColor == PieceColor.BLACK) {
//            if currentPosition!.y > position.y {
//                return false
//            }
//            if currentPosition!.y < 5 && deltaX == 1 {
//                return false
//            }
//        }
        return true
    }
    
    override func getFace() -> String {
        return self.pieceColor == PieceColor.RED ? "red-pawn" : "black-pawn"
    }
}
