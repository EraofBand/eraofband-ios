//
//  HomeTabView.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/06.
//

import UIKit

class HomeTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()

    }
    
    func setNavigationBar() {
        
        var leftBarButtons: [UIBarButtonItem] = []
        var rightBarButtons: [UIBarButtonItem] = []
        
        let logoImage = UIImage(named: "eob_logo_text")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        let logoView: UIImageView = UIImageView.init(image: logoImage)
        logoView.frame = CGRect(x: 0, y: 0, width: 108, height: 30)
        logoView.contentMode = .scaleAspectFit
        let logoBarButton = UIBarButtonItem(customView: logoView)
        var currWidth = logoBarButton.customView?.widthAnchor.constraint(equalToConstant: 110)
        currWidth?.isActive = true
        
        leftBarButtons.append(logoBarButton)
        
        self.navigationItem.leftBarButtonItems = leftBarButtons
        
        let searchImage = UIImage(named: "ic_search")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        let searchButtonView = UIView.init(frame: CGRect(x: 0, y: -10, width: 20, height: 20))
        let searchButton = UIButton.init()
        searchButton.backgroundColor = .clear
        searchButton.frame = searchButtonView.frame
        searchButton.setImage(searchImage, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonClicked(_:)), for: .touchUpInside)
        searchButtonView.addSubview(searchButton)
        
        let searchBarButton = UIBarButtonItem(customView: searchButtonView)
        currWidth = searchBarButton.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        
        let alarmImage = UIImage(named: "ic_home_alarm_off")
        let alarmButtonView = UIView.init(frame: CGRect(x: -20, y: -10, width: 19, height: 22))
        let alarmButton = UIButton.init()
        alarmButton.backgroundColor = .clear
        alarmButton.frame = alarmButtonView.frame
        alarmButton.setImage(alarmImage, for: .normal)
        alarmButton.addTarget(self, action: #selector(alarmButtonClicked(_:)), for: .touchUpInside)
        alarmButtonView.addSubview(alarmButton)
        
        let alarmBarButton = UIBarButtonItem(customView: alarmButtonView)
        currWidth = alarmBarButton.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        
        rightBarButtons.append(searchBarButton)
        rightBarButtons.append(alarmBarButton)
        
        self.navigationItem.rightBarButtonItems = rightBarButtons
        
    }
    
    @objc func searchButtonClicked(_ sender: UIButton!) {
        
        print("찾기 버튼 누름")
        
    }
    
    @objc func alarmButtonClicked(_ sender: UIButton!) {
        
        print("alarm button pressed!")
        
    }

}
