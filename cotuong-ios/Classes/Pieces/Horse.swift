//
//  Horse.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation

class Horse : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
        let deltaX = abs(currentPosition!.x - position.x)
        let deltaY = abs(currentPosition!.y - position.y)
        if (deltaX == 0 || deltaY == 0 || deltaX + deltaY != 3) {
            return false
        }
        if (deltaX == 2) {
            if let _ = board[position.y][(currentPosition!.x + position.x)/2] {
                return false
            }
        }
        if (deltaY == 2) {
            if let _ = board[(currentPosition!.y + position.y)/2][position.x] {
                return false
            }
        }
        return true
    }
}
