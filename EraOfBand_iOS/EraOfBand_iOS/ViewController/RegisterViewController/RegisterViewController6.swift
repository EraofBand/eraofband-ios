//
//  RegisterViewController6.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/05.
//

import UIKit
import Alamofire

class RegisterViewController6: UIViewController{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var admitBtn1: UIButton!
    @IBOutlet weak var admitBtn2: UIButton!
    @IBOutlet weak var admitAllBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var myRegisterData: RegisterData!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    
    var admitBool: [Bool] = [false, false, false]
    
    
    
    @IBAction func startBtnTapped(_ sender: Any) {
        
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/signin/" + appDelegate.myKakaoData.kakaoToken,
                   method: .post,
                   parameters: [
                    "birth": myRegisterData.birth,
                    "gender": myRegisterData.gender,
                    "nickName": myRegisterData.nickName,
                    "profileImgUrl": myRegisterData.profileImgUrl,
                    "region": myRegisterData.region,
                    "userSession": myRegisterData.userSession
                    ],
                   encoding: JSONEncoding.default,
                   headers: header).responseDecodable(of: LoginUserData.self){ response in
            switch response.result{
            case .success(let data):
                self.defaults.set(data.result.jwt, forKey: "jwt")
                self.defaults.set(data.result.userIdx, forKey: "userIdx")
                self.defaults.set(data.result.refresh, forKey: "refresh")
                self.defaults.set(data.result.expiration, forKey: "expiration")
                self.appDelegate.userSession = self.myRegisterData.userSession
                    
                    /*
                    self.appDelegate.jwt = getData.result.jwt ?? ""
                    self.appDelegate.userIdx = getData.result.userIdx!
                    self.appDelegate.userSession = self.myRegisterData.userSession*/
                    
                    guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController7") as? RegisterViewController7 else {return}
                    nextVC.myRegisterData = self.myRegisterData
                    self.navigationController?.pushViewController(nextVC, animated: true)
            case .failure(let err):
                print(err)
            }
            
        }
        
    }
    
    func checkForNextBtnEnabled(){
        if(admitBool[1] == true && admitBool[2] == true){
            nextBtn.isEnabled = true
        }else{
            nextBtn.isEnabled = false
        }
    }
    func changeBtnState(){
        
        if(admitBool[0] == true){
            admitAllBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }else{
            admitAllBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        
        if(admitBool[1] == true){
            admitBtn1.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }else{
            admitBtn1.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        
        if(admitBool[2] == true){
            admitBtn2.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }else{
            admitBtn2.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
    }
    
    @IBAction func admitAllBtnTapped(_ sender: Any) {
        
        if(admitBool[1] && admitBool[2]){
            for i in 0...2{
                admitBool[i] = false
            }
        }else{
            for i in 0...2{
                admitBool[i] = true
            }
        }
        
        checkForNextBtnEnabled()
        changeBtnState()
    }
    
    @IBAction func admitBtn1Tapped(_ sender: Any) {
        admitBool[1] = !admitBool[1]
        checkForNextBtnEnabled()
        changeBtnState()
    }
    
    @IBAction func admitBtn2Tapped(_ sender: Any) {
        admitBool[2] = !admitBool[2]
        checkForNextBtnEnabled()
        changeBtnState()
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLayout(){
        
        let text = titleLabel.text
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text! as NSString).range(of: "동의"))
        
        titleLabel.attributedText = attributedString
         
        nextBtn.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "서비스 약관에 동의해주세요!"
        
        setLayout()

        
        //print(myRegisterData!)
        //print(appDelegate.myKakaoData.kakaoToken)
        
    }

}

