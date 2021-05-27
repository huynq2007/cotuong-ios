//
//  Utils.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

enum PieceColor: String {
    case RED = "\u{001B}[0;31m" , BLACK = "\u{001B}[0;34m", CLEAR = "\u{001B}[0;0m"
}

struct Config {
    static let X_SIZE = 9
    static let Y_SIZE = 10
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
}
