//
//  GameViewController.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation
import UIKit

class GameViewController: UIViewController, BoardMovingHandler {
    
    private var game: Game = Game()
    private var selectedPieces: [Point] = []
    private var isReadyToStart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        startGame()
    }
    
    func startGame() {
        game.newGame(fen: Config.DEFAULT_FEN, level: .EASY)
        game.displayBoard(on: self)
        (game.board as! Board).boardMovingHandler = self
        
        // handle start button on board
        (game.board as! BoardView).onStartNewGameHandler = { (sender) -> () in
            if self.isReadyToStart {
                sender!.isHidden = true
            } else {
                sender!.isHidden = false
                // display Option box
                NewGameView.instance.showDialog()
            }
        }
        
        // display Option box before game start
        NewGameView.instance.onCompleteHandler = { (result, level, moveFirst) -> () in
            if result {
                self.game.setGameOption(level: level, moveFirst: moveFirst)
                self.registerTapHandler()
                self.isReadyToStart = true
            } else {
                self.isReadyToStart = false
            }
            self.game.makeBoardReady(isReady: self.isReadyToStart)
            (self.game.board as! BoardView).startButton?.isHidden = self.isReadyToStart
        }
        NewGameView.instance.showDialog()
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
        game.board?.foreachPiece(action: { (x, y) -> () in
            let piece = game.board?.getPieceAt(x: x, y: y)
            piece?.isSelected = false
        })
        sender.isSelected = true
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
    
    private func doMovingAction() -> Bool {
        
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

        return makingMovement()
    }
    
    func makingMovement() -> Bool {
        let srcPoint = Point(x: selectedPieces[0].x, y: selectedPieces[0].y)
        let dstPoint = Point(x: selectedPieces[1].x, y: selectedPieces[1].y)

        guard let srcPiece = game.board?.getPieceAt(x: srcPoint.x, y: srcPoint.y) else {
            return false
        }
        
        guard let dstPiece = game.board?.getPieceAt(x: dstPoint.x, y: dstPoint.y) else {        
            let result = srcPiece.moveTo(to: dstPoint)
            handleResult(result: result)
            return true
        }

        if srcPiece.pieceColor == dstPiece.pieceColor {
            return false
        }
        
        let result = srcPiece.moveTo(to: dstPoint)
        handleResult(result: result)
        return true
    }
    
    func handleResult(result: MoveResult) {
        switch result {
        case .MOVE_CHECK:
            MusicHelper.instancePlayer.playSound(for: "check2")
        case .MOVE_DRAW:
            MusicHelper.instancePlayer.playSound(for: "draw")
            AlertView.instance.showAlert(title: "CoTuong", message: "Game is Draw!", alertType: .success)
        case .MOVE_INVALID:
            showToast(message: "Invalid Movement!")
            MusicHelper.instancePlayer.playSound(for: "illegal")
        case .MOVE_MATE:
            let music = (game.board as! Board).MOVING_TURN == .RED ? "loss" : "win"
            let message = (game.board as! Board).MOVING_TURN == .RED ? "You lose!" : "You win!"
            MusicHelper.instancePlayer.playSound(for: music)
            AlertView.instance.showAlert(title: "CoTuong", message: message, alertType: .normal)
        case .MOVE_NORMAL:
            MusicHelper.instancePlayer.playSound(for: "move")
        case .MOVE_NONE:
            break
        }
    }
    
    func onBoardMovingComplete() {
        let result = (game.board as! Board).AIMove()
        handleResult(result: result)
    }
}
