//
//  TabmanViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/11.
//

import UIKit
import Tabman
import Pageboy

class MyTabManViewController: TabmanViewController {

    var viewControllers: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.1672143638, green: 0.1786631942, blue: 0.208065331, alpha: 1)
        
        let portfolioVC = UIStoryboard.init(name: "MypageTab", bundle: nil).instantiateViewController(withIdentifier: "PortfolioViewController")
        let bandVC = UIStoryboard.init(name: "MypageTab", bundle: nil).instantiateViewController(withIdentifier: "BandViewController")
        let lessonVC = UIStoryboard.init(name: "MypageTab", bundle: nil).instantiateViewController(withIdentifier: "LessonViewController")
        
        viewControllers.append(portfolioVC)
        viewControllers.append(bandVC)
        viewControllers.append(lessonVC)
        
        self.dataSource = self
        
        // MARK: 페이지 하단 탭 바
        let bar = TMBar.ButtonBar()
        settingMypageTabBar(ctBar: bar) //함수 추후 구현
        addBar(bar, dataSource: self, at: .top)
       
    }
    
}

extension MyTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        // MARK: - Tab 안 글씨들
        switch index {
        case 0:
            return TMBarItem(title: "포트폴리오")
        case 1:
            return TMBarItem(title: "소속밴드")
        case 2:
            return TMBarItem(title: "신청 레슨")
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


func settingMypageTabBar (ctBar : TMBar.ButtonBar) {
    ctBar.layout.transitionStyle = .snap
    
    ctBar.layout.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    
    ctBar.layout.contentMode = .fit
    
    ctBar.backgroundView.style = .clear
    
    // 선택 / 안선택 색 + font size
    ctBar.buttons.customize { (button) in
        button.tintColor = .white
        button.selectedTintColor = UIColor(named: "on_icon_color")
        button.font = UIFont(name: "Pretendard-Medium", size: 14)!
        button.selectedFont = UIFont(name: "Pretendard-Bold", size: 14)!
    }
    
    // 인디케이터
    ctBar.indicator.weight = .custom(value: 2)
    ctBar.indicator.tintColor = UIColor(named: "on_icon_color")
}
