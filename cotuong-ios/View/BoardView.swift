//
//  BoardView.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/23/21.
//

import Foundation

import UIKit

class BoardView: UIView {
    
    private var model: Board? {
        return self as? Board
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        self.isOpaque = false
        self.backgroundColor = UIColor(patternImage: UIImage(named: "board")!)
    }
    
    func setupConstraints() {
    }
    
    var lineWidth: CGFloat = 1 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    
    // Chess board has 9 rows grid and 8 columns grid
    let boardRowsNumber: CGFloat = 9
    let boardColsNumber: CGFloat = 8
    
    private lazy var boardHeight: CGFloat = min(self.bounds.size.width, self.bounds.size.height)
    
    private lazy var gridWidth: CGFloat = self.boardHeight / self.boardRowsNumber
    
    private var boardWidth: CGFloat {
        return gridWidth * boardColsNumber
    }
    
    private var boardCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func calculateBoardCoordinates() -> [[CGPoint]] {
        let startX = boardCenter.x - (boardWidth / 2),
            startY = boardCenter.y - (boardHeight / 2),
            endX = startX + boardWidth,
            endY = startY + boardHeight
        
        var ret = [[CGPoint]]()
        
        for _y in stride(from: startY, through: endY, by: gridWidth) {
            var foo = [CGPoint]()
            
            for _x in stride(from: startX, through: endX, by: gridWidth) {
                foo.append(CGPoint(x: _x, y: _y))
            }
            
            ret.append(foo)
        }
        
        return ret
    }
    
    public func resetBoardCoordinates() {
        //boardCoordinates.removeAll()
    }
    
    private func pathForLine(startPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        path.close()
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        
        let m = self.calculateBoardCoordinates()
        
        for i in 0...9 {
            // Draw the horizontal line
            pathForLine(startPoint: m[i][0], endPoint: m[i][8]).stroke()
            // Draw the vertical line
            if (i == 0 || i == 8) {
                pathForLine(startPoint: m[0][i], endPoint: m[9][i]).stroke()
            } else if (i != 9) {
                pathForLine(startPoint: m[0][i], endPoint: m[4][i]).stroke()
                pathForLine(startPoint: m[5][i], endPoint: m[9][i]).stroke()
            }
        }
        
        // Draw diagonal
        pathForLine(startPoint: m[0][3], endPoint: m[2][5]).stroke()
        pathForLine(startPoint: m[0][5], endPoint: m[2][3]).stroke()
        pathForLine(startPoint: m[7][3], endPoint: m[9][5]).stroke()
        pathForLine(startPoint: m[7][5], endPoint: m[9][3]).stroke()
    }
}
