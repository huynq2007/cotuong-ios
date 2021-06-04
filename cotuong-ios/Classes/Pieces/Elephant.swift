//
//  Elephant.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation

class Elephant : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
//        let deltaX = abs(currentPosition!.x - position.x)
//        let deltaY = abs(currentPosition!.y - position.y)
//        if (deltaX != 2 || deltaY != 2) {
//            return false
//        }
//        if (pieceColor == PieceColor.BLACK && position.y > 4) {
//            return false
//        }
//        if (pieceColor == PieceColor.RED && position.y < 5) {
//            return false
//        }
        return true
    }
    
    override func getFace() -> String {
        return self.pieceColor == PieceColor.RED ? "red-bishop" : "black-bishop"
    }
}
