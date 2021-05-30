//
//  GameViewController.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation
import UIKit

extension UIViewController {

func showToast(message : String) {
    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
} }

class GameViewController: UIViewController {
    
    private var game: Game = Game()
    private var selectedPiece: Piece?
    private var board: Board?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // do your stuffs here
        game.newGame()
        self.board = game.board as? Board
        
        drawBoard(board: self.board!)
        
        registerTapHandler()
    }
    
    func registerTapHandler() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(getCoordinates))
        tap.numberOfTapsRequired = 1
        self.board!.addGestureRecognizer(tap)
    }
    
    func drawBoard(board: Board) {
        // draw board
        board.frame = view.frame
        self.view.addSubview(board)
        
        // draw pieces
        for y in 0..<Config.Y_SIZE {
            for x in 0..<Config.X_SIZE {
                if let piece = board.getPieceAt(x: x, y: y) {
                    piece.setBackgroundImage(UIImage(named: piece.getFace()), for: .normal)
                    piece.setImage(UIImage(named: "cursor"), for: .selected)
                    piece.frame = CGRect(origin: .zero, size: CGSize(width: board.gridWidth, height: board.gridWidth))
                    piece.center = board.boardCoordinates[y][x]
                    piece.addTarget(self, action: #selector(performOperation(sender:)), for: .touchUpInside)
                    self.view.addSubview(piece)
                }
            }
        }
    }
    
    @objc func performOperation(sender: Piece!) {
        print("you selected: \(sender.currentPosition!.x) \(sender.currentPosition!.y)")
        if let _ = sender {
            selectedPiece = sender
            UIView.animate(withDuration: 0.5, animations: { () in
                for y in 0..<Config.Y_SIZE {
                    for x in 0..<Config.X_SIZE {
                        if let view = self.board?.getPieceAt(x: x, y: y) {
                            view.isSelected = false
                        }
                    }
                }
            })
            sender.isSelected = true
        }
    }
    
    @objc func getCoordinates(recognizer: UITapGestureRecognizer) {
        let boardView = game.board as! BoardView
        let position = recognizer.location(in: boardView),
         x = round(position.x),
         y = round(position.y)
        let boardOrigin: CGPoint = boardView.boardCoordinates[0][0]
        let gridWidth = boardView.gridWidth
        let boardTermination = boardView.boardCoordinates[9][8]
        if(y < boardOrigin.y - gridWidth / 2 || y > boardTermination.y + gridWidth / 2) {
            return
        }
        let col = Int(round((x - boardOrigin.x) / gridWidth)),
            row = Int(round((y - boardOrigin.y) / gridWidth))
        print("move to: \(col) \(row)")
        if let _ = selectedPiece {
            guard let move = selectedPiece?.moveTo(to: Point(x: col, y: row)) else {
                self.showToast(message: "Invalid movement!")
                return
                
            }
            if !move {
                self.showToast(message: "Invalid movement!")
                return
            }
            UIView.animate(withDuration: 0.5, animations: { () in
                for y in 0..<Config.Y_SIZE {
                    for x in 0..<Config.X_SIZE {
                        if let view = self.board?.getPieceAt(x: x, y: y) {
                            self.selectedPiece?.center = boardView.boardCoordinates[row][col]
                            view.isSelected = false
                        }
                    }
                }
            })
        }
    }
}
