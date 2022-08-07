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
import Alamofire

class SettingViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
    
    func deleteUser(alert: UIAlertAction!){
        //print("탈퇴하기")
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/status/" + String(appDelegate.userIdx!),
                   method: .patch,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success:
                do{
                    print("탈퇴 성공..")
                    self.dismiss(animated: true)
                }catch{
                    print(error.localizedDescription)
                }
            default:
                return
            }
        }
    }
    
    @IBAction func deleteUserBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: "회원 탈퇴", message: "정말 탈퇴하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "네🥲", style: .destructive, handler: deleteUser))
        alert.addAction(UIAlertAction(title: "아니오!", style: .cancel))
        
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "설정"
        self.navigationItem.titleView?.tintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
    }
    

}
