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
    //    private var selectedPiece: Piece?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // do your stuffs here
        game.newGame(view: self)
        game.displayBoard()
        registerTapHandler()
    }
    
    func registerTapHandler() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(getCoordinates))
        tap.numberOfTapsRequired = 1
        (game.board as! BoardView).addGestureRecognizer(tap)
        
        for y in 0..<Config.Y_SIZE {
            for x in 0..<Config.X_SIZE {
                if let piece = game.board?.getPieceAt(x: x, y: y) {
                    piece.addTarget(self,action: #selector(selectPiece(sender:)), for: .touchUpInside)
                }
            }
        }
    }
    
    @objc func selectPiece(sender: Piece!) {
        MusicHelper.sharedHelper.playSound(for: "click")
        if let _ = sender {
            for y in 0..<Config.Y_SIZE {
                for x in 0..<Config.X_SIZE {
                    if let view = game.board?.getPieceAt(x: x, y: y) {
                        view.isSelected = false
                    }
                }
            }
            sender.isSelected = true
        }
    }
    
    @objc func getCoordinates(recognizer: UITapGestureRecognizer) {
        let boardView = (game.board as! BoardView)
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
        
        for y in 0..<Config.Y_SIZE {
            for x in 0..<Config.X_SIZE {
                if let piece = game.board?.getPieceAt(x: x, y: y), piece.isSelected == true {
                    let result = piece.moveTo(to: Point(x: col, y: row))
                    if !result {
                        self.showToast(message: "Invalid movement!")
                    }
                    break
                }
            }
        }
    }
}
