//
//  Cannon.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation

class Cannon : Piece {
    override func validateMovement(to position: Point, status board: [[Piece?]]) -> Bool {
//        let deltaX = abs(currentPosition!.x - position.x)
//        let deltaY = abs(currentPosition!.y - position.y)
//        if(deltaX > 0 && deltaY > 0) {
//            return false
//        }
//        var blockCount = 0
//        if (currentPosition!.x == position.x) {
//            let minY = min(currentPosition!.y, position.y)
//            let maxY = max(currentPosition!.y, position.y)
//            for step in minY + 1..<maxY {
//                if let _ = board[step][currentPosition!.x] {
//                    blockCount += 1
//                }
//            }
//        } else if (currentPosition!.y == position.y) {
//            let minX = min(currentPosition!.x, position.x)
//            let maxX = max(currentPosition!.x, position.x)
//            for step in minX + 1..<maxX {
//                if let _ = board[currentPosition!.y][step] {
//                    blockCount += 1
//                }
//            }
//        }
//        if let piece = board[position.y][position.x] {
//            if (piece.pieceColor != self.pieceColor) {
//                if blockCount > 1 {
//                    return false
//                }
//            }else {
//                return false
//            }
//        }else {
//            if blockCount > 0 {
//                return false
//            }
//        }        
        return true
    }
    
    override func getFace() -> String {
        return self.pieceColor == PieceColor.RED ? "red-cannon" : "black-cannon"
    }
}
