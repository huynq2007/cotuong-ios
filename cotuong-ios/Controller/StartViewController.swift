//
//  StartViewController.swift
//  cotuong-ios
//
//  Created by hnguyen on 5/27/21.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update screen display region
        Config.DISPLAY_BOUND = self.view.bounds
    }
}
