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
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var sessionData: [String] = ["보컬", "기타", "베이스", "드럼", "키보드"]

    var userData: OtherUserDataModel?

    
    @IBAction func followingBtnTapped(_ sender: Any) {
        
        guard let followVC = storyboard?.instantiateViewController(withIdentifier: "FollowTabManViewController") as? FollowTabManViewController else {return}
        
        followVC.myNickName = userNickNameLabel.text
        followVC.currentPage = "Following"
        followVC.userIdx = userIdx
        
        navigationController?.pushViewController(followVC, animated: true)
    }
    @IBAction func followerBtnTapped(_ sender: Any) {
        guard let followVC = storyboard?.instantiateViewController(withIdentifier: "FollowTabManViewController") as? FollowTabManViewController else {return}
        
        followVC.myNickName = userNickNameLabel.text
        followVC.currentPage = "Follower"
        followVC.userIdx = userIdx
        
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func doUnFollow(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/unfollow/" + String(userIdx!),
                   method: .delete,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success:
                self.followButton.setTitle("팔로우", for: .normal)
                self.followButton.backgroundColor = #colorLiteral(red: 0.1057075635, green: 0.4936558008, blue: 0.9950549006, alpha: 1)
            default:
                return
            }
        }
    }
    
    func doFollow(){
        
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/follow/" + String(userIdx!),
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success:
                self.followButton.setTitle("언팔로우", for: .normal)
                self.followButton.backgroundColor = #colorLiteral(red: 0.1672143638, green: 0.1786631942, blue: 0.208065331, alpha: 1)
            default:
                return
            }
        }
    }
    
    @IBAction func followBtnTapped(_ sender: Any) {
        if(followButton.titleLabel!.text == "팔로우"){
            doFollow()
        }else{
            doUnFollow()
        }
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
        
        if userData?.result.getUser.follow == 0{
            followButton.setTitle("팔로우", for: .normal)
            followButton.backgroundColor = #colorLiteral(red: 0.1057075635, green: 0.4936558008, blue: 0.9950549006, alpha: 1)
        }else{
            followButton.setTitle("언팔로우", for: .normal)
            followButton.backgroundColor = #colorLiteral(red: 0.1672143638, green: 0.1786631942, blue: 0.208065331, alpha: 1)
        }
        
        self.title = userData?.result.getUser.nickName
        
        userInfoLabel.text = "\(userData?.result.getUser.region ?? "") / \(userAge) / \(userGender)"

        userIntroLabel.text = userData?.result.getUser.introduction
        
        userPofolLabel.text = String((userData?.result.getUser.pofolCount)!)
        
        userFollowerButton.setTitle(String((userData?.result.getUser.followeeCount)!), for: .normal)
        
        userFollowingButton.setTitle(String((userData?.result.getUser.followerCount)!), for: .normal)
        
        let sessionNum: Int = (userData?.result.getUser.userSession)!
        userSessionLabel.text = sessionData[sessionNum]
        
        containerView.updateHeight(containerViewHeight, (userData?.result.getUser.pofolCount)!)
        
        guard let imageUrl = userData?.result.getUser.profileImgUrl else { return }
        if let url = URL(string: imageUrl) {
            userImageView.load(url: url)
            userImageView.contentMode = .scaleAspectFill
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
                    let getData = try JSONDecoder().decode(OtherUserDataModel.self, from: dataJSON)
                    
                    print(getData)
                    
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
        topView.layer.cornerRadius = 15
        
        userSessionLabel.layer.cornerRadius = 10
        userSessionLabel.layer.backgroundColor = #colorLiteral(red: 0.1057075635, green: 0.4936558008, blue: 0.9950549006, alpha: 1)
        userSessionLabel.textColor = .white
        userSessionLabel.font = UIFont(name: "Pretendard-Medium", size: 12)
        
        followButton.layer.cornerRadius = 15
        followButton.tintColor = .white
        
        messageButton.layer.cornerRadius = 15
        messageButton.backgroundColor = #colorLiteral(red: 0.1672143638, green: 0.1786631942, blue: 0.208065331, alpha: 1)
        messageButton.tintColor = #colorLiteral(red: 0.7675942779, green: 0.7675942779, blue: 0.7675942779, alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        appDelegate.otherUserIdx = self.userIdx
    }
    

}
