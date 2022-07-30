//
//  BandRecruitTabmanViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/29.
//

import UIKit
import Tabman
import Pageboy

class BandRecruitTabmanViewController: TabmanViewController{
    
    private var viewControllers: Array<UIViewController> = []
    var bandIdx: Int?
    var bandInfo: BandInfoResult?
    
    func setTabBarLayout(ctBar : TMBar.ButtonBar){
        ctBar.layout.transitionStyle = .snap
        
        ctBar.layout.contentMode = .fit
        
        ctBar.backgroundView.style = .clear
        
        // 선택 / 안선택 색 + font size
        ctBar.buttons.customize { (button) in
            button.tintColor = .white
            button.selectedTintColor = UIColor(named: "on_icon_color")
            button.font = UIFont(name: "Pretendard-Medium", size: 14)!
            button.selectedFont = UIFont(name: "Pretendard-Bold", size: 14)!
        }
        
        ctBar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        // 인디케이터
        ctBar.indicator.weight = .custom(value: 2)
        ctBar.indicator.tintColor = UIColor(named: "on_icon_color")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let introVC = UIStoryboard.init(name: "BandRecruit", bundle: nil).instantiateViewController(withIdentifier: "BandIntroViewController") as! BandIntroViewController
        let recruitVC = UIStoryboard.init(name: "BandRecruit", bundle: nil).instantiateViewController(withIdentifier: "RecruitViewController") as! RecruitViewController
        let albumVC = UIStoryboard.init(name: "BandRecruit", bundle: nil).instantiateViewController(withIdentifier: "BandAlbumViewController") as! BandAlbumViewController
        
        introVC.bandInfo = bandInfo
        albumVC.bandInfo = bandInfo
        
        viewControllers.append(introVC)
        viewControllers.append(recruitVC)
        viewControllers.append(albumVC)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        setTabBarLayout(ctBar: bar)
        
        addBar(bar, dataSource: self, at: .top)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
}

extension BandRecruitTabmanViewController: PageboyViewControllerDataSource, TMBarDataSource{
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        // MARK: - Tab 안 글씨들
        switch index {
        case 0:
            return TMBarItem(title: "밴드소개")
        case 1:
            return TMBarItem(title: "세션모집")
        case 2:
            return TMBarItem(title: "앨범")
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

