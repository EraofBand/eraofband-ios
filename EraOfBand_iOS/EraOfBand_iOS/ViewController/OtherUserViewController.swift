//
//  OtherUserViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/15.
//

import UIKit
import Alamofire

class OtherUserViewController: UIViewController {

    var userIdx: Int?
    
    @IBOutlet weak var userNickNameLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var userIntroLabel: UILabel!
    @IBOutlet weak var userSessionLabel: UILabel!
    @IBOutlet weak var followingLabel: UIButton!
    @IBOutlet weak var followerLabel: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userData: UserDataModel?
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUserInfo(){
        userNickNameLabel.text = userData?.result.getUser.nickName
        
        let year = DateFormatter()
        year.dateFormat = "yyyy"
        let currentYear = year.string(from: Date())
        let birthYear = (userData?.result.getUser.birth.components(separatedBy: "-")[0])!
        let userAge = Int(currentYear)! - Int(birthYear)! + 1
        
        var userGender: String
        if userData?.result.getUser.gender == "MALE"{
            userGender = "남"
        }else{
            userGender = "여"
        }
        
        userInfoLabel.text = "\(userData?.result.getUser.region ?? "") / \(userAge) / \(userGender)"

        userIntroLabel.text = userData?.result.getUser.introduction
    }
    
    func getUserData(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/" + String(userIdx!),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success(let obj):
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    let getData = try JSONDecoder().decode(UserDataModel.self, from: dataJSON)
                    
                    self.userData = getData
                    
                    self.setUserInfo()
                }catch{
                    print(error.localizedDescription)
                }
            default:
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(userIdx!)
        getUserData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
