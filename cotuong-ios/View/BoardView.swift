//
//  BoardView.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/23/21.
//

import Foundation

import UIKit

class BoardView: UIView {
    
    var onStartNewGameHandler: ((_ sender: UIButton?) -> ())?
    var startButton: UIButton?
    private var topBar: StatusBar!
    private var bottomBar: StatusBar!
    
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
        
        // add start game button
        startButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 100.0, height: 35.0)))
        startButton?.center = Config.BOARD_CENTER
        startButton!.backgroundColor = .green
        startButton!.setTitle("Start Game", for: .normal)
        startButton!.addTarget(self, action: #selector(starGame), for: .touchUpInside)
        self.addSubview(startButton!)
        
        // add status bar on top
        topBar = StatusBar(frame: CGRect(origin: CGPoint(x: 0, y: Config.START_Y - Config.PIECE_SIZE/2 - 30), size: CGSize(width: self.frame.width, height: 30)))
        topBar.isTop = true
        self.addSubview(topBar)
        
        // add status bar on bottom
//        bottomBar = StatusBar(frame: CGRect(origin: CGPoint(x: 0, y: Config.END_Y + Config.PIECE_SIZE/2 + 30), size: CGSize(width: self.frame.width, height: 30)))
        bottomBar = StatusBar()
        bottomBar.isTop = false
        self.addSubview(bottomBar)
        
        updateMovingStatus()
        
//        let view = UIView(frame: CGRect(origin: CGPoint(x: Config.START_X, y: Config.START_Y - 25.0), size: CGSize(width: 50, height: 50)))
//        view.backgroundColor = .red
//        self.addSubview(view)
    }
    
    @objc func starGame(sender: UIButton!) {
        self.onStartNewGameHandler?(sender)
    }
    
    func setupConstraints() {
        let barHeight: CGFloat = 30.0
        let startBarY = Config.START_Y - ( Config.PIECE_SIZE/2 + barHeight + 5)
        let endBarY: CGFloat = Config.START_Y + Config.PIECE_SIZE * 9 + ( Config.PIECE_SIZE/2 + 5)
        
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            topBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            topBar.topAnchor.constraint(equalTo: self.topAnchor, constant: startBarY),
            topBar.widthAnchor.constraint(equalToConstant: Config.DISPLAY_BOUND.width),
            topBar.heightAnchor.constraint(equalToConstant: barHeight),
        ])
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            bottomBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            bottomBar.topAnchor.constraint(equalTo: self.topAnchor, constant: endBarY),
            bottomBar.widthAnchor.constraint(equalToConstant: Config.DISPLAY_BOUND.width),
            bottomBar.heightAnchor.constraint(equalToConstant: barHeight),
        ])
    }
    
    func updateMovingStatus() {
        topBar.thinkingSide = (self as! Board).MOVING_TURN
        bottomBar.thinkingSide = (self as! Board).MOVING_TURN
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
