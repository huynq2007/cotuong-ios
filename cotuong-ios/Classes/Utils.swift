//
//  Utils.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation
import UIKit

enum PieceColor: String {
    case RED = "\u{001B}[0;31m" , BLACK = "\u{001B}[0;34m", CLEAR = "\u{001B}[0;0m"
}

struct Config {
    
    // Board's default settings
    static let X_SIZE = 9
    static let Y_SIZE = 10
    static let DEFAULT_FEN = "rheakaehr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RHEAKAEHR w - - 0 1"
    
    // Screen size settings
    static var DISPLAY_BOUND: CGRect = .zero
    static let BOARD_HEIGHT: CGFloat = min(DISPLAY_BOUND.size.width, DISPLAY_BOUND.size.height)
    static let BOARD_CENTER: CGPoint = CGPoint(x: DISPLAY_BOUND.midX, y: DISPLAY_BOUND.midY)
    static let BOARD_WIDTH: CGFloat = PIECE_SIZE * 8
    static let PIECE_SIZE: CGFloat = BOARD_HEIGHT / 9
    static let START_X: CGFloat = BOARD_CENTER.x - (BOARD_WIDTH / 2)
    static let START_Y: CGFloat = BOARD_CENTER.y - (BOARD_HEIGHT / 2)
    static let END_X: CGFloat = START_X + BOARD_WIDTH
    static let END_Y: CGFloat = START_Y + BOARD_HEIGHT
}

enum PieceType: String {
    case RROOK="R"
    case BROOK="r"
    case RHORSE="H"
    case BHORSE="h"
    case RELEPHANT="E"
    case BELEPHANT="e"
    case RADVISOR="A"
    case BADVISOR="a"
    case RKING="K"
    case BKING="k"
    case RCANON="C"
    case BCANON="c"
    case RPAWN="P"
    case BPAWN="p"
}

struct Point {
    // (0, 0) will be at top-left
    var x = 0, y = 0
    
    func toScreenCoordinate() -> CGPoint {
        let startX = Config.BOARD_CENTER.x - (Config.BOARD_WIDTH / 2)
        let startY = Config.BOARD_CENTER.y - (Config.BOARD_HEIGHT / 2)
        let cX = startX + Config.PIECE_SIZE * CGFloat(x)
        let cY = startY + Config.PIECE_SIZE * CGFloat(y)
        return CGPoint(x: cX, y: cY)
    }
}

enum GameLevel: Int32 {
    case EASY = 3
    case INTER = 5
    case HARD = 7
    case SUPER = 15
}
