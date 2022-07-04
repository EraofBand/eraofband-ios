//
//  BottomTabBarViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/04.
//

import UIKit

class CustomTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    // MARK: Initializing
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.selectedIndex = 2
        setupMiddleButton()
        
    }
    
    // MARK: Home Button Custom
    func setupMiddleButton() {
        
        // 버튼 위치,크기 커스텀
        let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 30, y: 20, width: 60, height: 60))
        
        middleButton.setBackgroundImage(UIImage(named: "ic_home"), for: .normal)
        
        self.tabBar.addSubview(middleButton)
        middleButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        self.view.layoutIfNeeded()
        
    }
    
    @objc func menuButtonAction(sender: UIButton) {
        // 탭 바 아이템 중 몇 번째 인덱스인지 설정
        self.selectedIndex = 2
    }

}
