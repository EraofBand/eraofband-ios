//
//  BandListTanManController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/25.
//

import Tabman
import Pageboy
import UIKit

class BandListTabManController: TabmanViewController {
    
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let entireVC = UIStoryboard.init(name: "BandList", bundle: nil).instantiateViewController(withIdentifier: "AllListViewController")
        
        viewControllers.append(entireVC)
        viewControllers.append(entireVC)
        viewControllers.append(entireVC)
        viewControllers.append(entireVC)
        viewControllers.append(entireVC)
        viewControllers.append(entireVC)
        
        self.dataSource = self
        
        // MARK: 페이지 하단 탭 바
        let bar = TMBar.ButtonBar()
        settingBandListTabBar(ctBar: bar) //함수 추후 구현
        addBar(bar, dataSource: self, at: .top)
       
    }
    
}

extension BandListTabManController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        // MARK: - Tab 안 글씨들
        switch index {
        case 0:
            return TMBarItem(title: "전체")
        case 1:
            return TMBarItem(title: "보컬")
        case 2:
            return TMBarItem(title: "기타")
        case 3:
            return TMBarItem(title: "베이스")
        case 4:
            return TMBarItem(title: "키보드")
        case 5:
            return TMBarItem(title: "드럼")
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

func settingBandListTabBar(ctBar : TMBar.ButtonBar) {
    ctBar.layout.transitionStyle = .snap
    
    ctBar.layout.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
    
    ctBar.layout.interButtonSpacing = 70
    
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
