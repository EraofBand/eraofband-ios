//
//  BottomTabBarViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/03.
//

import UIKit

class BottomTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    // MARK: Initializing
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.selectedIndex = 1
        
    }


}
