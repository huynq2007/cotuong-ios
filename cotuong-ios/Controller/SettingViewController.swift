//
//  SettingViewController.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.        
    }
    
    @IBAction func toggle(_ sender: UISwitch) {
        let switcher = sender
        if !switcher.isOn {
            MusicHelper.sharedHelper.stopBackgroundMusic()
        }else {
            MusicHelper.sharedHelper.playBackgroundMusic()
        }
    }
    
}
