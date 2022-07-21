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
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNickNameLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var userIntroLabel: UILabel!
    @IBOutlet weak var userSessionLabel: UILabel!
    @IBOutlet weak var userFollowingButton: UIButton!
    @IBOutlet weak var userFollowerButton: UIButton!
    @IBOutlet weak var userPofolLabel: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userData: UserDataModel?
    var sessionData: [String] = ["보컬", "기타", "베이스", "드럼", "키보드"]
    
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
        
        userPofolLabel.text = String((userData?.result.getUser.pofolCount)!)
        
        userFollowerButton.setTitle(String((userData?.result.getUser.followerCount)!), for: .normal)
        
        userFollowingButton.setTitle(String((userData?.result.getUser.followeeCount)!), for: .normal)
        
        let sessionNum: Int = (userData?.result.getUser.userSession)!
        userSessionLabel.text = sessionData[sessionNum]
        
        containerView.updateHeight(containerViewHeight, (userData?.result.getUser.pofolCount)!)
        
        guard let imageUrl = userData?.result.getUser.profileImgUrl else { return }
        if let url = URL(string: imageUrl) {
            userImageView.load(url: url)
        } else {
            userImageView.image = UIImage(named: "default_image")
        }
        userImageView.setRounded()
    }
    
    func getUserData(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/info/" + String(userIdx!),
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

        getUserData()
        
        infoView.layer.cornerRadius = 15
        followButton.layer.cornerRadius = 15
        messageButton.layer.cornerRadius = 15
        
        userSessionLabel.layer.cornerRadius = 10
        userSessionLabel.layer.borderWidth = 1
        userSessionLabel.layer.borderColor = UIColor(named: "on_icon_color")?.cgColor
        
    }
    

}
