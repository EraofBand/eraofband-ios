//
//  MypageTabView.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/06.
//

import UIKit

class MypageTabViewController: UIViewController {
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var sessionView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let navigationBarAppearance = UINavigationBarAppearance()
//        navigationBarAppearance.backgroundColor = .clear
//        navigationController.navigationBar.standardAppearance = navigationBarAppearance
//        navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance

        
        // 프로필 view, 세션 view 모서리 둥글게
        infoView.layer.cornerRadius = 15
        sessionView.layer.cornerRadius = 15
        bottomView.layer.cornerRadius = 15
        
        self.navigationController?.view.backgroundColor = .clear

    }
    
    
}
