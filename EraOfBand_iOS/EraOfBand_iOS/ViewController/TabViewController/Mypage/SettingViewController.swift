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
import MessageUI

class SettingViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    @IBAction func SendMailBtnTapped(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            let bodyString = """
                             이곳에 내용을 작성해주세요.
                             """
            
            composeViewController.setToRecipients(["lsh929500@gmail.com"])
            composeViewController.setSubject("<밴드의 시대> 문의 및 의견")
            composeViewController.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func blockBtnTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        print("테스트")
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                if(self.appDelegate.isAutoLogin){
                    guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
                    loginVC.modalPresentationStyle = .fullScreen
                    self.appDelegate.isAutoLogin = false
                    self.present(loginVC, animated: true)
                }else{
                    self.dismiss(animated: true)
                }

            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteUser(alert: UIAlertAction!){
        //print("탈퇴하기")
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        print(appDelegate.baseUrl + "/users/status/" + String(appDelegate.userIdx!))
        
        AF.request(appDelegate.baseUrl + "/users/status/" + String(appDelegate.userIdx!),
                   method: .patch,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success:
                print(response)
                if(self.appDelegate.isAutoLogin){
                    guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
                    loginVC.modalPresentationStyle = .fullScreen
                    self.appDelegate.isAutoLogin = false
                    self.present(loginVC, animated: true)
                }else{
                    self.dismiss(animated: true)
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

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
