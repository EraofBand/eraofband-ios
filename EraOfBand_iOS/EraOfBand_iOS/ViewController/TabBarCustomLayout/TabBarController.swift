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
        
        // 각 탭 아이콘 설정, 뷰컨트롤러 연결
        let tab1 = UIStoryboard(name: "CommunityTab", bundle: nil).instantiateViewController(withIdentifier: "communityNC")
        let communityImage = UIImage(named: "ic_community")!
        let communityIcon = resizeImage(image: communityImage, height: 41)
        tab1.tabBarItem = UITabBarItem(title: "", image: communityIcon, tag: 0)
        tab1.tabBarItem.selectedImage?.withTintColor(UIColor(named: "on_icon_color")!)
        tab1.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -25, right: 0)
        
        let tab2 = UIStoryboard(name: "BoardTab", bundle: nil).instantiateViewController(withIdentifier: "BoardNC")
        let noticeImage = UIImage(named: "ic_posting")!
        let noticeIcon = resizeImage(image: noticeImage, height: 41)
        tab2.tabBarItem = UITabBarItem(title: "", image: noticeIcon, tag: 1)
        tab2.tabBarItem.selectedImage?.withTintColor(UIColor(named: "on_icon_color")!)
        tab2.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -25, right: 0)
        
        let tab3 = UIStoryboard(name: "HomeTab", bundle: nil).instantiateViewController(withIdentifier: "HomeNC")
        
        let tab4 = UIStoryboard(name: "MessageTab", bundle: nil).instantiateViewController(withIdentifier: "MessageNC")
        let messageImage = UIImage(named: "ic_message")!
        let messageIcon = resizeImage(image: messageImage, height: 41)
        tab4.tabBarItem = UITabBarItem(title: "", image: messageIcon, tag: 3)
        tab4.tabBarItem.selectedImage?.withTintColor(UIColor(named: "on_icon_color")!)
        tab4.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -25, right: 0)
        
        let tab5 = UIStoryboard(name: "MypageTab", bundle: nil).instantiateViewController(withIdentifier: "MypageNC")
        let mypageImage = UIImage(named: "ic_mypage")!
        let mypageIcon = resizeImage(image: mypageImage, height: 41)
        tab5.tabBarItem = UITabBarItem(title: "", image: mypageIcon, tag: 4)
        tab5.tabBarItem.selectedImage?.withTintColor(UIColor(named: "on_icon_color")!)
        tab5.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -25, right: 0)
        
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
    
    func resizeImage(image: UIImage, height: CGFloat) -> UIImage {
        let scale = height / image.size.height
        let newWidth = image.size.width * scale
        
        let size = CGSize(width: newWidth, height: height)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }

}
