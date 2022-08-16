//
//  SearchTabBarView.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/06.
//

import Foundation
import UIKit
import Tabman
import Pageboy

class SearchTabManViewController: TabmanViewController {

    var currentSearch = "user"
    var viewControllers: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "UserSearchViewController") as! UserSearchViewController
        let bandVC = self.storyboard?.instantiateViewController(withIdentifier: "BandSearchViewController") as! BandSearchViewController
        let lessonVC = self.storyboard?.instantiateViewController(withIdentifier: "LessonSearchViewController") as! LessonSearchViewController
        
        viewControllers.append(userVC)
        viewControllers.append(bandVC)
        viewControllers.append(lessonVC)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        settingSearchTabBar(ctBar: bar)
        addBar(bar, dataSource: self, at: .top)
        
    }
    
}

extension SearchTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        // MARK: - Tab 안 글씨들
        switch index {
        case 0:
            return TMBarItem(title: "유저")
        case 1:
            return TMBarItem(title: "밴드")
        case 2:
            return TMBarItem(title: "레슨")
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
        print(currentSearch)
        
        if(currentSearch == "user"){
            return .first
        }else if(currentSearch == "band"){
            return .at(index: 1)
        }else{
            return .last
        }
    }
    
}

func settingSearchTabBar (ctBar : TMBar.ButtonBar) {
    ctBar.layout.transitionStyle = .snap
    
    ctBar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    ctBar.layout.contentMode = .fit
    ctBar.layout.interButtonSpacing = 25
    
    ctBar.backgroundView.style = .clear
    
    // 선택 / 안선택 색 + font size
    ctBar.buttons.customize { (button) in
        button.tintColor = .white
        button.selectedTintColor = UIColor(named: "accent_color")
        button.font = UIFont(name: "Pretendard-Medium", size: 14)!
        button.selectedFont = UIFont(name: "Pretendard-Bold", size: 14)!
    }
    
    // 인디케이터
    ctBar.indicator.weight = .custom(value: 2)
    ctBar.indicator.tintColor = UIColor(named: "accent_color")
}
