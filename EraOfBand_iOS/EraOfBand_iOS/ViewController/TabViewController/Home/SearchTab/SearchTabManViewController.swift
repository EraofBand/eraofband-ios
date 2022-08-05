//
//  SearchTabManViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/04.
//

import Foundation
import UIKit
import Tabman
import Pageboy

class SearchTabManViewController: TabmanViewController {
    
    var viewControllers: Array<UIViewController> = []
    
    var userResult: [userResultInfo] = []
    var bandResult: [bandInfo] = []
    var lessonResult: [lessonInfo] = []
    
    func setTab(_ userResult: [userResultInfo], _ bandResult: [bandInfo], _ lessonResult: [lessonInfo]) {
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "UserSearchViewController") as! UserSearchViewController
        userVC.userResult = userResult
        let bandVC = self.storyboard?.instantiateViewController(withIdentifier: "BandSearchViewController") as! BandSearchViewController
        bandVC.bandResult = bandResult
        let lessonVC = self.storyboard?.instantiateViewController(withIdentifier: "LessonSearchViewController") as! LessonSearchViewController
        lessonVC.lessonResult = lessonResult
        
        viewControllers.append(userVC)
        viewControllers.append(bandVC)
        viewControllers.append(lessonVC)
        
        self.dataSource = self
        
        // MARK: 페이지 하단 탭 바
        let bar = TMBar.ButtonBar()
        settingSearchTabBar(ctBar: bar) //함수 추후 구현
        addBar(bar, dataSource: self, at: .top)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTab(userResult, bandResult, lessonResult)
       
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
        return nil
    }
    
    
}

func settingSearchTabBar (ctBar : TMBar.ButtonBar) {
    ctBar.layout.transitionStyle = .snap
    
    ctBar.layout.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    ctBar.layout.contentMode = .fit
    
    let backgroundView = UIView()
    backgroundView.backgroundColor = .black
    ctBar.backgroundView.style = .custom(view: backgroundView)
    
    // 선택 / 안선택 색 + font size
    ctBar.buttons.customize { (button) in
        button.tintColor = .white
        button.selectedTintColor = #colorLiteral(red: 0.1057075635, green: 0.4936558008, blue: 0.9950549006, alpha: 1)
        button.font = UIFont(name: "Pretendard-Medium", size: 18)!
        button.selectedFont = UIFont(name: "Pretendard-Bold", size: 18)!
    }
    
    // 인디케이터
    ctBar.indicator.weight = .custom(value: 2)
    ctBar.indicator.tintColor = UIColor(named: "on_icon_color")
}
