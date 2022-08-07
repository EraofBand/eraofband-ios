//
//  FollowTableViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/19.
//

import UIKit
import Tabman
import Pageboy

class FollowTabManViewController: TabmanViewController{
    
    var currentPage = "Following"
    
    private var viewControllers: Array<UIViewController> = []
    var myNickName: String?
    var userIdx: Int?
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = myNickName
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let followingVC = UIStoryboard.init(name: "FollowingTable", bundle: nil).instantiateViewController(withIdentifier: "FollowingTableViewController") as! FollowingTableViewController
        followingVC.userIdx = userIdx
        
        let followerVC = UIStoryboard.init(name: "FollowingTable", bundle: nil).instantiateViewController(withIdentifier: "FollowerTableViewController") as! FollowerTableViewController
        followerVC.userIdx = userIdx
        
        viewControllers.append(followingVC)
        viewControllers.append(followerVC)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        
        addBar(bar, dataSource: self, at: .top)
        self.settingTabBar(ctBar: bar)
    }
}

extension FollowTabManViewController: PageboyViewControllerDataSource, TMBarDataSource{
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
        switch index {
        case 0:
            return TMBarItem(title: "팔로잉")
        case 1:
            return TMBarItem(title: "팔로워")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        if(currentPage == "Following"){
            return .first
        }else{
            return .last
        }
    }
    
    
    func settingTabBar (ctBar : TMBar.ButtonBar) {
        ctBar.layout.transitionStyle = .snap
        
        ctBar.layout.contentMode = .fit
        
        ctBar.backgroundView.style = .clear
        
        // 선택 / 안선택 색 + font size
        ctBar.buttons.customize { (button) in
            button.selectedTintColor = UIColor(named: "on_icon_color")
            button.tintColor = .white
            button.font = UIFont.systemFont(ofSize: 16)
            button.selectedFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
        
        // 인디케이터
        ctBar.indicator.weight = .custom(value: 2)
        ctBar.indicator.tintColor = UIColor(named: "on_icon_color")
    }
}


