//
//  Rook.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation

class Rook : Piece {    
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
//        let deltaX = abs(currentPosition!.x - position.x)
//        let deltaY = abs(currentPosition!.y - position.y)
//        if(deltaX > 0 && deltaY > 0) {
//            return false
//        }
//        
//        if (currentPosition!.x == position.x) {
//            for step in currentPosition!.y + 1..<position.y {
//                if let _ = board[step][currentPosition!.x] {
//                    return false
//                }
//            }
//        }else if (currentPosition!.y == position.y) {
//            for step in currentPosition!.x + 1..<position.x {
//                if let _ = board[step][currentPosition!.x] {
//                    return false
//                }
//            }
//        }
        
        return true
    }
    
    override func getFace() -> String {
        return self.pieceColor == PieceColor.RED ? "red-rook" : "black-rook"
    }
}
