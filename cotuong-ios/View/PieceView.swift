//
//  PieceVIew.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/29/21.
//

import Foundation

import UIKit

class PieceView: UIButton {
    
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
    }
    
    func setupConstraints() {
    }
}
