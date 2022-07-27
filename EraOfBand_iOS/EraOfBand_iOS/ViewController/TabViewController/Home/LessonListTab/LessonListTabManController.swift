//
//  LessonListTabManController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/27.
//

import Tabman
import Pageboy
import UIKit

class LessonListTabManController: TabmanViewController {
    
    var viewControllers: [UIViewController] = []
    var region: String = "전체"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bandListVC = UIStoryboard.init(name: "BandList", bundle: nil).instantiateViewController(withIdentifier: "BandListTableViewController") as! BandListTableViewController
        bandListVC.tabNum = 5
        bandListVC.region = region
        
        let vocalListVC = UIStoryboard.init(name: "BandList", bundle: nil).instantiateViewController(withIdentifier: "BandListTableViewController") as! BandListTableViewController
        vocalListVC.tabNum = 0
        vocalListVC.region = region
        
        let guitarListVC = UIStoryboard.init(name: "BandList", bundle: nil).instantiateViewController(withIdentifier: "BandListTableViewController") as! BandListTableViewController
        guitarListVC.tabNum = 1
        guitarListVC.region = region
        
        let baseListVC = UIStoryboard.init(name: "BandList", bundle: nil).instantiateViewController(withIdentifier: "BandListTableViewController") as! BandListTableViewController
        baseListVC.tabNum = 2
        baseListVC.region = region
        
        let keyboardListVC = UIStoryboard.init(name: "BandList", bundle: nil).instantiateViewController(withIdentifier: "BandListTableViewController") as! BandListTableViewController
        keyboardListVC.tabNum = 3
        keyboardListVC.region = region
        
        let drumListVC = UIStoryboard.init(name: "BandList", bundle: nil).instantiateViewController(withIdentifier: "BandListTableViewController") as! BandListTableViewController
        drumListVC.tabNum = 4
        drumListVC.region = region
        
        viewControllers.append(bandListVC)
        viewControllers.append(vocalListVC)
        viewControllers.append(guitarListVC)
        viewControllers.append(baseListVC)
        viewControllers.append(keyboardListVC)
        viewControllers.append(drumListVC)
        
        self.dataSource = self
        
        // MARK: 페이지 하단 탭 바
        
        let bar = TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMBlockBarIndicator>()
        settingBandListTabBar(ctBar: bar) //함수 추후 구현
        addBar(bar, dataSource: self, at: .top)
       
    }
    
    
}

extension LessonListTabManController: PageboyViewControllerDataSource, TMBarDataSource {
    
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
