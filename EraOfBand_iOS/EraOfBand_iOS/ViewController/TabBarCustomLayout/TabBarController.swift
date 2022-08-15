//
//  BottomTabBarViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/04.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    // MARK: Initializing
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Tab Bar Icon Custom
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.selectedIndex = 2
        
        // 탭 바 아이콘 폰트 설정
        let font = UIFont(name: "Pretendard-Bold", size: 13)!
        
        // 각 탭 아이콘 설정, 뷰컨트롤러 연결
        let tab1 = UIStoryboard(name: "CommunityTab", bundle: nil).instantiateViewController(withIdentifier: "communityNC")
        tab1.tabBarItem = UITabBarItem(title: "커뮤니티", image: UIImage(named: "ic_community_off"), selectedImage: UIImage(named: "ic_community_on"))
        tab1.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        let tab2 = UIStoryboard(name: "NoticeTab", bundle: nil).instantiateViewController(withIdentifier: "NoticeTabViewController")
        tab2.tabBarItem = UITabBarItem(title: "게시판", image: UIImage(named: "ic_notice_off"), selectedImage: UIImage(named: "ic_notice_on"))
        tab2.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        let tab3 = UIStoryboard(name: "HomeTab", bundle: nil).instantiateViewController(withIdentifier: "HomeNC")
        
        let tab4 = UIStoryboard(name: "MessageTab", bundle: nil).instantiateViewController(withIdentifier: "MessageNC")
        tab4.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(named: "ic_message_off"), selectedImage: UIImage(named: "ic_message_on"))
        tab4.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        let tab5 = UIStoryboard(name: "MypageTab", bundle: nil).instantiateViewController(withIdentifier: "MypageNC")
        tab5.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "ic_mypage_off"), selectedImage: UIImage(named: "ic_mypage_on"))
        tab5.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        viewControllers = [tab1, tab2, tab3, tab4, tab5]
        
        setupMiddleButton()
        
        
    }
    
    // MARK: Home Button Custom
    func setupMiddleButton() {
        
        // 홈 탭 버튼 위치,크기 커스텀
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
