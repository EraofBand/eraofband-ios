//
//  BandListViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/25.
//

import UIKit

class BandListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func setNavigationBar() {
        
        self.navigationItem.title = "생성된 밴드 목록"
        
        let backImage = UIImage(systemName: "chevron.left")
        backImage?.withTintColor(.white)
        let backButton = UIButton()
        backButton.backgroundColor = .clear
        backButton.setImage(backImage, for: .normal)
        //backButton.addTarget(self, action: #selector(<#T##@objc method#>), for: .touchUpInside)
        
        //let backBarButton = uibar
        
    }
    


}
