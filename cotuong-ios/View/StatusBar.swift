//
//  StatusBar.swift
//  cotuong-ios
//
//  Created by hnguyen on 6/12/21.
//

import Foundation
import UIKit

class StatusBar: UIView {
    
    @IBOutlet var parentView: UIView!
    
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var avatar1: UIImageView!
    @IBOutlet weak var clock1: UIImageView!
    @IBOutlet weak var avatar2: UIImageView!
    @IBOutlet weak var clock2: UIImageView!
    
    private var _isTop: Bool = false
    private var _thinkingSide: PieceColor = .RED
    var isTop: Bool {
        get {
            return _isTop
        }
        set(top) {
            _isTop = top
            if _isTop {
//                avatar1.isHidden = false
//                avatar2.isHidden = true
                statusText.textAlignment = .left
                statusText.text = "Computer"
            } else {
//                avatar1.isHidden = true
//                avatar2.isHidden = false
                statusText.textAlignment = .right
                statusText.text = "Player"
            }
        }
    }
    
    var thinkingSide: PieceColor {
        get {
            return _thinkingSide
        }
        set(side) {
            _thinkingSide = side
            if _thinkingSide == .RED {
                if _isTop {
                    clock1.isHidden = true
                    clock2.isHidden = true
                } else {
                    clock1.isHidden = true
                    clock2.isHidden = false
                }
            } else if _thinkingSide == .BLACK {
                if _isTop {
                    clock1.isHidden = false
                    clock2.isHidden = true
                } else {
                    clock1.isHidden = true
                    clock2.isHidden = true
                }
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(frame: CGRect(origin: .zero, size: .zero))
        setupConstraints()
    }
    
    func setupView(frame: CGRect) {
        Bundle.main.loadNibNamed("StatusBar", owner: self, options: nil)
        clock1.isHidden = true
        clock2.isHidden = true
        
        self.addSubview(parentView)
    }
    
    func setupConstraints() {
        parentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            parentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            parentView.widthAnchor.constraint(equalTo: self.widthAnchor),
            parentView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
