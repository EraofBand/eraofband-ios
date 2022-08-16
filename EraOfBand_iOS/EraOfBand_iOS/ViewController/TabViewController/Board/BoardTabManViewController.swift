//
//  BoardTabManViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/16.
//

import UIKit
import Tabman
import Pageboy

class BoardTabManViewController: TabmanViewController{
    
    var viewControllers: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let freeBoardVC = UIStoryboard.init(name: "BoardTab", bundle: nil).instantiateViewController(withIdentifier: "FreeBoardViewController")
        let questionBoardVC = UIStoryboard.init(name: "BoardTab", bundle: nil).instantiateViewController(withIdentifier: "QuestionBoardViewController")
        let promotionBoardVC = UIStoryboard.init(name: "BoardTab", bundle: nil).instantiateViewController(withIdentifier: "PromotionBoardViewController")
        let tradeBoardVC = UIStoryboard.init(name: "BoardTab", bundle: nil).instantiateViewController(withIdentifier: "TradeBoardViewController")
        let myBoardVC = UIStoryboard.init(name: "BoardTab", bundle: nil).instantiateViewController(withIdentifier: "MyBoardViewController")
        
        viewControllers.append(freeBoardVC)
        viewControllers.append(questionBoardVC)
        viewControllers.append(promotionBoardVC)
        viewControllers.append(tradeBoardVC)
        viewControllers.append(myBoardVC)
        
        self.dataSource = self
        
        // MARK: 페이지 하단 탭 바
        let bar = TMBar.ButtonBar()
        settingBoardTabBar(ctBar: bar)
        addBar(bar, dataSource: self, at: .top)
        
    }
    
}

extension BoardTabManViewController: PageboyViewControllerDataSource, TMBarDataSource{
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        // MARK: - Tab 안 글씨들
        switch index {
        case 0:
            return TMBarItem(title: "자유")
        case 1:
            return TMBarItem(title: "질문")
        case 2:
            return TMBarItem(title: "홍보")
        case 3:
            return TMBarItem(title: "거래")
        case 4:
            return TMBarItem(title: "MY")
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

func settingBoardTabBar (ctBar : TMBar.ButtonBar) {
    ctBar.layout.transitionStyle = .snap
    
    ctBar.layout.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    ctBar.layout.contentMode = .fit
    
    let backgroundView = UIView()
    backgroundView.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
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
