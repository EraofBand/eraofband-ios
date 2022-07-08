//
//  LoginViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/03.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController{
    
    @IBOutlet weak var backgroundImg: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func kakaoBtnTapped(_ sender: Any) {
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
           loginWithApp()
        }else {
            loginWithWeb()
        }
    }

    // 카카오톡 앱으로 로그인
    func loginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }else{
                print("loginWithKakaoTalk() success.")
                print(oauthToken ?? "token error")
                _ = oauthToken
            }
        }
    }

    // 카카오톡 웹으로 로그인
    func loginWithWeb(){
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }else{
                print("loginWithKakaoTalk() success.")
                print(oauthToken ?? "token error")
                _ = oauthToken
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(appDelegate.baseUrl)
    }
}
