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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let portfolioVC = UIStoryboard.init(name: "OtherUser", bundle: nil).instantiateViewController(withIdentifier: "OtherPofolViewController")
        let bandVC = UIStoryboard.init(name: "OtherUser", bundle: nil).instantiateViewController(withIdentifier: "OtherBandViewController")
        
        viewControllers.append(portfolioVC)
        viewControllers.append(bandVC)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        settingTabBar(ctBar: bar)
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
