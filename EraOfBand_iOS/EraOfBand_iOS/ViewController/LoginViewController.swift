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
import Alamofire

class LoginViewController: UIViewController{
    
    @IBOutlet weak var backgroundImg: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //카카오 데이터 구조체
    /*
    struct kakaoData{
        var kakaoToken: String
        var kakaoUserName: String
        
        init(kakaoToken: String, kakaoUserName: String){
            self.kakaoToken = kakaoToken
            self.kakaoUserName = kakaoUserName
        }
    }*/
    
    //로그인 이후 카카오 유저 정보 가져오기
    func getKakaoData(kakaoToken: String){
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        UserApi.shared.me() { [self](user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                
                let myKakaoData = kakaoData.init(kakaoToken: kakaoToken, kakaoUserName: (user?.kakaoAccount?.profile?.nickname)! as String, kakaoEmail: (user?.kakaoAccount?.email)! as String)
                self.appDelegate.myKakaoData = myKakaoData
                
                /*
                AF.request(self.appDelegate.baseUrl + "/users/signin/" + appDelegate.myKakaoData.kakaoEmail,
                           method: .get,
                           encoding: JSONEncoding.default,
                           headers: header).responseJSON{ response in
                    print(response)
                }*/
                
                guard let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterNavigationController") as? RegisterNavigationController else {return}
                registerVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                
                //registerVC.myKakaoData = myKakaoData
                
                self.present(registerVC, animated: true)
            }
        }
    }
    
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
                //self.kakaoToken =
                
                self.getKakaoData(kakaoToken: (oauthToken?.accessToken)! as String)
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
                //self.kakaoToken = (oauthToken?.accessToken)! as String

                self.getKakaoData(kakaoToken: (oauthToken?.accessToken)! as String)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(appDelegate.baseUrl)
    }
}
