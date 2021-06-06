//
//  GameViewController.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    
    private var game: Game = Game()
    private var selectedPieces: [Point] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update screen display region
        Config.DISPLAY_BOUND = self.view.bounds
        
        startGame()
    }
    
    func startGame() {
//        let fen = "4kae2/1H2a4/1c2e2c/9/9/9/9/1R2C4/4A4/4K4 w - - 0 1"
//        game.newGame(fen: fen, level: .EASY)
        game.newGame(fen: Config.DEFAULT_FEN, level: .HARD)
        game.displayBoard(on: self)
        
        registerTapHandler()
    }
    
    func registerTapHandler() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(getCoordinates))
        tap.numberOfTapsRequired = 1
        (game.board as! BoardView).addGestureRecognizer(tap)
        
        game.board?.foreachPiece(action: { (x, y) in
            if let piece = game.board?.getPieceAt(x: x, y: y) {
                piece.addTarget(self,action: #selector(selectPiece(sender:)), for: .touchUpInside)
            }
        })
    }
    
    @objc func selectPiece(sender: Piece!) {
        MusicHelper.instancePlayer.playSound(for: "click")
        self.selectedPieces.append(Point(x: sender.currentPosition!.x, y: sender.currentPosition!.y))
        if doMovingAction() {
            selectedPieces.removeAll()
        }
    }
    
    @objc func getCoordinates(recognizer: UITapGestureRecognizer) {
        let boardView = (game.board as! BoardView)
        let position = recognizer.location(in: boardView),
            x = round(position.x),
            y = round(position.y)
        let boardOrigin: CGPoint = CGPoint(x: Config.START_X, y: Config.START_Y)
        let boardTermination = CGPoint(x: Config.END_X, y: Config.END_Y)
        
        if(y < boardOrigin.y - Config.PIECE_SIZE / 2 || y > boardTermination.y + Config.PIECE_SIZE / 2) {
            return
        }
        let col = Int(round((x - boardOrigin.x) / Config.PIECE_SIZE))
        let row = Int(round((y - boardOrigin.y) / Config.PIECE_SIZE))
        
        self.selectedPieces.append(Point(x: col, y: row))
        if doMovingAction() {
            selectedPieces.removeAll()
        }
    }
    
    func doMovingAction() -> Bool {
        
        if (game.board as! Board).MOVING_TURN == .BLACK {
            return false
        }
        
        if (game.board as! Board).IS_GAME_OVER {
            return false
        }
        
        if selectedPieces.count < 2 {
            return false
        }
        
        if selectedPieces.count > 2 {
            selectedPieces.remove(at: 0)
        }
        
        let srcPoint = Point(x: selectedPieces[0].x, y: selectedPieces[0].y)
        let dstPoint = Point(x: selectedPieces[1].x, y: selectedPieces[1].y)
        
        guard let srcPiece = game.board?.getPieceAt(x: srcPoint.x, y: srcPoint.y) else {
            return false
        }
        guard let dstPiece = game.board?.getPieceAt(x: dstPoint.x, y: dstPoint.y) else {
            if !srcPiece.moveTo(to: dstPoint) {
                showToast(message: "Invalid Movement!")
                MusicHelper.instancePlayer.playSound(for: "illegal")
                return false
            }
            return true
        }
        
        if srcPiece.pieceColor == dstPiece.pieceColor {
            return false
        } else {
            if !srcPiece.moveTo(to: dstPoint) {
                showToast(message: "Invalid Movement!")
                MusicHelper.instancePlayer.playSound(for: "illegal")
                return false
            }
            return true
        }
    }
}
