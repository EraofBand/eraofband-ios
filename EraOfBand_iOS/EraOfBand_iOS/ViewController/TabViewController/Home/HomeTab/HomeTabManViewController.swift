//
//  HomeTabManViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/23.
//

import UIKit
import Tabman
import Pageboy

class HomaeTabManViewController: TabmanViewController {
    
    var viewControllers: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sessionMatchVC = UIStoryboard.init(name: "SessionMatch", bundle: nil).instantiateViewController(withIdentifier: "SessionMatchViewController")
        let lessonMatchVC = UIStoryboard.init(name: "LessonMatch", bundle: nil).instantiateViewController(withIdentifier: "LessonMatchViewController")
        let wishBandVC = UIStoryboard.init(name: "WishBand", bundle: nil).instantiateViewController(withIdentifier: "WishBandViewController")
        let wishLessonVC = UIStoryboard.init(name: "WishLesson", bundle: nil).instantiateViewController(withIdentifier: "WishLessonViewController")
        
        viewControllers.append(sessionMatchVC)
        viewControllers.append(lessonMatchVC)
        viewControllers.append(wishBandVC)
        viewControllers.append(wishLessonVC)

        
        self.dataSource = self
        
        // MARK: 페이지 하단 탭 바
        let bar = TMBar.ButtonBar()
        settingHomeTabBar(ctBar: bar) //함수 추후 구현
        addBar(bar, dataSource: self, at: .top)
       
    }
    
}

extension HomaeTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        // MARK: - Tab 안 글씨들
        switch index {
        case 0:
            return TMBarItem(title: "세션 매칭")
        case 1:
            return TMBarItem(title: "레슨 매칭")
        case 2:
            return TMBarItem(title: "찜한 밴드")
        case 3:
            return TMBarItem(title: "찜한 레슨")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
        
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        //위에서 선언한 vc array의 count를 반환
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    
}

func settingHomeTabBar (ctBar : TMBar.ButtonBar) {
    ctBar.layout.transitionStyle = .snap
    
    ctBar.layout.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    ctBar.layout.interButtonSpacing = 35
    
    ctBar.backgroundView.style = .clear
    
    // 선택 / 안선택 색 + font size
    ctBar.buttons.customize { (button) in
        button.tintColor = .white
        button.selectedTintColor = UIColor(named: "on_icon_color")
        button.font = UIFont(name: "Pretendard-Medium", size: 17)!
        button.selectedFont = UIFont(name: "Pretendard-Medium", size: 17)!
    }
    
    // 인디케이터
    ctBar.indicator.weight = .custom(value: 2)
    ctBar.indicator.tintColor = UIColor(named: "on_icon_color")
}
