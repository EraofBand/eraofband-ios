//
//  MypageTabView.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/06.
//

import UIKit
import Tabman
import Pageboy

class MypageTabViewController: TabmanViewController {
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var sessionView: UIView!
    
    var viewControllers: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.layer.cornerRadius = 15
        sessionView.layer.cornerRadius = 15
        
        self.dataSource = self
        
        
//        // MARK: 페이지 하단 탭 바
//        let bar = TMBar.ButtonBar()
//        settingTabBar(ctBar: bar) //함수 추후 구현
//        addBar(bar, dataSource: self, at: .top)
        
        // 프로필 view, 세션 view 모서리 둥글게
        
        

    }
    
    
}

extension MypageTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        //        let item = TMBarItem(title: "")
        //        item.title = "Page \(index)"
        //        item.image = UIImage(named: "image.png")
        //
        //        return item
        
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


func settingTabBar (ctBar : TMBar.ButtonBar) {
    ctBar.layout.transitionStyle = .snap
    // 왼쪽 여백주기
    ctBar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 13.0, bottom: 0.0, right: 20.0)
    
    // 간격
    ctBar.layout.interButtonSpacing = 35
    
    ctBar.backgroundView.style = .blur(style: .light)
    
    // 선택 / 안선택 색 + font size
    ctBar.buttons.customize { (button) in
        button.tintColor = UIColor(named: "on_icon_color")
        button.selectedTintColor = .white
        button.font = UIFont.systemFont(ofSize: 16)
        button.selectedFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    // 인디케이터 (영상에서 주황색 아래 바 부분)
    ctBar.indicator.weight = .custom(value: 2)
    ctBar.indicator.tintColor = UIColor(named: "on_icon_color")
}
