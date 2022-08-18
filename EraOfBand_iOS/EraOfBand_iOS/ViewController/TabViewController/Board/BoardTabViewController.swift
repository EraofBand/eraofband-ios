//
//  NoticeTabView.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/06.
//

import UIKit

class BoardTabViewController: UIViewController {
    
    @IBAction func floatingBtnTapped(_ sender: Any) {
        
    }
    
    func setLayout(){
        //self.navigationController?.isNavigationBarHidden = true
        setNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    func setNavigationBar() {
        
        var leftBarButtons: [UIBarButtonItem] = []
        
        let mypageLabel = UILabel()
        mypageLabel.text = "게시판"
        mypageLabel.font = UIFont(name: "Pretendard-Medium", size: 25)
        mypageLabel.textColor = .white
        
        let mypageBarButton = UIBarButtonItem(customView: mypageLabel)
        
        leftBarButtons.append(mypageBarButton)
        
        self.navigationItem.leftBarButtonItems = leftBarButtons
        
    }
}
