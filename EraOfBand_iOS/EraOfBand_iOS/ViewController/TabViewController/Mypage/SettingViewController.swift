//
//  SettingViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/17.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class SettingViewController: UIViewController {
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                self.dismiss(animated: true)
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "설정"
        self.navigationItem.titleView?.tintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
    }
    

}
