//
//  BottomTabBarViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/04.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    // MARK: Initializing
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.selectedIndex = 2
        
        let controller1 = CommunityTabView()
        controller1.tabBarItem = UITabBarItem(title: "커뮤니티", image: UIImage(named: "ic_community_off"), selectedImage: UIImage(named: "ic_community_on"))
        controller1.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 12)!], for: .normal)
        
        let controller2 = NoticeTabView()
        controller2.tabBarItem = UITabBarItem(title: "게시판", image: UIImage(named: "ic_notice_off"), selectedImage: UIImage(named: "ic_notice_on"))
        controller2.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 12)!], for: .normal)
        
        let controller3 = HomeTabView()
        
        let controller4 = MessageTabView()
        controller4.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(named: "ic_message_off"), selectedImage: UIImage(named: "ic_message_on"))
        controller4.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 12)!], for: .normal)
        
        let controller5 = MypageTabView()
        controller5.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "ic_mypage_off"), selectedImage: UIImage(named: "ic_mypage_on"))
        controller5.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 12)!], for: .normal)
        
        viewControllers = [controller1, controller2, controller3, controller4, controller5]
        
        setupMiddleButton()
        
    }
    
    // MARK: Home Button Custom
    func setupMiddleButton() {
        
        // 버튼 위치,크기 커스텀
        let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 33, y: 15, width: 66, height: 66))
        
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
