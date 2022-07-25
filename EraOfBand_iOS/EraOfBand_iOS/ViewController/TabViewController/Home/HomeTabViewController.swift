//
//  HomeTabView.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/06.
//

import UIKit

class HomeTabViewController: UIViewController {

    @IBOutlet weak var floatingStackView: UIStackView!
    @IBOutlet weak var floatingButton: UIButton!
    @IBOutlet weak var creatStackView: UIStackView!
    
    var isShowFloating: Bool = false
    
    lazy var floatingDimView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.alpha = 0
        view.isHidden = true
        
        self.view.insertSubview(view, belowSubview: self.floatingStackView)
        
        return view
    }()
    
    @IBAction func floatingAction(_ sender: Any) {
        if isShowFloating {
            UIView.animate(withDuration: 0.1) {
                self.creatStackView.isHidden = true
                self.view.layoutIfNeeded()
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.floatingDimView.alpha = 0
            }) { (_) in
                self.floatingDimView.isHidden = true
            }
        } else {
            
            self.floatingDimView.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                self.floatingDimView.alpha = 1
            }
            
            self.creatStackView.isHidden = false
            self.creatStackView.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                self.creatStackView.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
        
        isShowFloating = !isShowFloating
        
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
        
        let searchImage = UIImage(named: "ic_search")
        let searchButton = UIButton()
        searchButton.backgroundColor = .clear
        searchButton.setImage(searchImage, for: .normal)
        searchButton.addTarget(self, action: #selector(self.searchButtonClicked), for: .touchUpInside)
        
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        currWidth = searchBarButton.customView?.widthAnchor.constraint(equalToConstant: 20)
        currWidth?.isActive = true
        var currheight = searchBarButton.customView?.heightAnchor.constraint(equalToConstant: 20)
        currheight?.isActive = true
        
        let alarmImage = UIImage(named: "ic_home_alarm_off")
        let alarmButton = UIButton()
        alarmButton.backgroundColor = .clear
        alarmButton.setImage(alarmImage, for: .normal)
        alarmButton.addTarget(self, action: #selector(self.alarmButtonClicked), for: .touchUpInside)
        
        let alarmBarButton = UIBarButtonItem(customView: alarmButton)
        currWidth = alarmBarButton.customView?.widthAnchor.constraint(equalToConstant: 19)
        currWidth?.isActive = true
        currheight = alarmBarButton.customView?.heightAnchor.constraint(equalToConstant: 22)
        currheight?.isActive = true
        
        let negativeSpacer1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                             target: nil, action: nil)
        negativeSpacer1.width = 15
        
        let negativeSpacer2 = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                             target: nil, action: nil)
        negativeSpacer2.width = 30
                
        rightBarButtons.append(negativeSpacer1)
        rightBarButtons.append(searchBarButton)
        rightBarButtons.append(negativeSpacer2)
        rightBarButtons.append(alarmBarButton)
        
        self.navigationItem.rightBarButtonItems = rightBarButtons
        
    }
    
    @objc func searchButtonClicked(_ sender: UIButton) {
        
        print("찾기 버튼 누름")
        
    }
    
    @objc func alarmButtonClicked(_ sender: UIButton) {
        
        print("alarm button pressed!")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        creatStackView.layer.cornerRadius = 10

    }
    
}
