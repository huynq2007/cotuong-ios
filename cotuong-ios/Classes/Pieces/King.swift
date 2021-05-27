//
//  King.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation

class King : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
        let deltaX = abs(currentPosition!.x - position.x)
        let deltaY = abs(currentPosition!.y - position.y)
        if (deltaY + deltaX != 1) {
            return false
        }
        if (position.x < 3 || position.x > 5) {
            return false
        }
        if (color == PieceColor.BLACK && position.y > 2) {
            return false
        }
        if (color == PieceColor.RED && position.y < 7) {
            return false
        }
        return true
    }
}
