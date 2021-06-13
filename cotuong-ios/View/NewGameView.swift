//
//  NewGameView.swift
//  cotuong-ios
//
//  Created by hnguyen on 6/7/21.
//

import Foundation
import UIKit

class NewGameView: UIView {
    
    static let instance = NewGameView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var moveSwitcher: UISegmentedControl!
    @IBOutlet weak var levelSlider: UISlider!
    
    var onCompleteHandler: ((_ result: Bool, _ level: Int, _ moveFirst: Int) -> ())?
    
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
        Bundle.main.loadNibNamed("NewGameView", owner: self, options: nil)        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        levelSlider.minimumValue = 1
        levelSlider.maximumValue = 4
        levelSlider.value = 2
    }
    
    func setupConstraints() {
    }
    
    func showDialog() {
        UIApplication.shared.keyWindow?.addSubview(self.parentView)
    }
    
    @IBAction func onStart(_ sender: UIButton) {
        parentView.removeFromSuperview()
        onCompleteHandler?(true, Int(levelSlider.value), moveSwitcher.selectedSegmentIndex)
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        parentView.removeFromSuperview()
        onCompleteHandler?(false, Int(levelSlider.value), moveSwitcher.selectedSegmentIndex)
    }
}
