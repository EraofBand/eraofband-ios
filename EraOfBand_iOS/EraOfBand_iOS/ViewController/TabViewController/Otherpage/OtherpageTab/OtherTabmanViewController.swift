//
//  OtherTabmanViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/19.
//

import UIKit
import Tabman
import Pageboy

class OtherTabmanViewController: TabmanViewController {
    
    var viewControllers: Array<UIViewController> = []
    var userData: OtherUser?
    var userIdx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let portfolioVC = UIStoryboard.init(name: "OtherUser", bundle: nil).instantiateViewController(withIdentifier: "OtherPofolViewController") as! OtherPofolViewController
        let bandVC = UIStoryboard.init(name: "OtherUser", bundle: nil).instantiateViewController(withIdentifier: "OtherBandViewController") as! OtherBandViewController
        
        portfolioVC.userData = self.userData
        portfolioVC.userIdx = self.userIdx
        bandVC.userData = self.userData
        
        viewControllers.append(portfolioVC)
        viewControllers.append(bandVC)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        settingOtherTabBar(ctBar: bar)
        addBar(bar, dataSource: self, at: .top)
        
    }
}

extension OtherTabmanViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        // MARK: - Tab 안 글씨들
        switch index {
        case 0:
            return TMBarItem(title: "포트폴리오")
        case 1:
            return TMBarItem(title: "소속밴드")
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

func settingOtherTabBar (ctBar : TMBar.ButtonBar) {
    ctBar.layout.transitionStyle = .snap
    
    ctBar.layout.contentInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
    
    ctBar.layout.contentMode = .fit
    ctBar.layout.interButtonSpacing = 10
    
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
