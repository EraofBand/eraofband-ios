//
//  OtherUserViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/15.
//

import UIKit
import Alamofire
import Firebase

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
    
    var chatRoomIdx: String = "none"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var sessionData: [String] = ["보컬", "기타", "베이스", "드럼", "키보드"]

    var userData: OtherUser?
    
    var chatListData: [messageListInfo] = [] //내 채팅 리스트
    let chatReference = Database.database().reference()
    
    /* 서버에서 채팅방 정보 리스트 가져오는 함수 */
    func getMessageList(completion: @escaping () -> Void) {
        
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/chat/chat-room"
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: MessageListData.self){ response in
            
            switch response.result{
            case .success(let messageInfoData):
                print("message: \(messageInfoData)")
                self.chatListData = messageInfoData.result
                completion()
                
            case .failure(let err):
                print(err)
            }
            
        }
        
    }
    
    @IBAction func messageBtnTapped(_ sender: Any) {
        
        getMessageList {
            for i in 0..<self.chatListData.count{
                if(self.chatListData[i].nickName == self.userData?.getUser.nickName){
                    print(self.chatListData[i].chatRoomIdx)
                    self.chatRoomIdx = self.chatListData[i].chatRoomIdx
                    break
                }
            }
            
            let messageVC = ChatViewController()
            messageVC.title = self.userData?.getUser.nickName
            messageVC.chatRoomIdx = self.chatRoomIdx
            messageVC.otherUserIdx = self.userData?.getUser.userIdx
            self.navigationController?.pushViewController(messageVC, animated: true)
        }
    }
    
    
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
        userNickNameLabel.text = userData?.getUser.nickName
        
        let year = DateFormatter()
        year.dateFormat = "yyyy"
        let currentYear = year.string(from: Date())
        let birthYear = (userData?.getUser.birth.components(separatedBy: "-")[0])!
        let userAge = Int(currentYear)! - Int(birthYear)! + 1
        
        var userGender: String
        if userData?.getUser.gender == "MALE"{
            userGender = "남"
        }else{
            userGender = "여"
        }
        
        if userData?.getUser.follow == 0{
            followButton.setTitle("팔로우", for: .normal)
            followButton.backgroundColor = #colorLiteral(red: 0.1057075635, green: 0.4936558008, blue: 0.9950549006, alpha: 1)
        }else{
            followButton.setTitle("언팔로우", for: .normal)
            followButton.backgroundColor = #colorLiteral(red: 0.1672143638, green: 0.1786631942, blue: 0.208065331, alpha: 1)
        }
        
        self.title = userData?.getUser.nickName
        
        userInfoLabel.text = "\(userData?.getUser.region ?? "") / \(userAge) / \(userGender)"

        userIntroLabel.text = userData?.getUser.introduction
        
        userPofolLabel.text = String((userData?.getUser.pofolCount)!)
        
        userFollowerButton.setTitle(String((userData?.getUser.followeeCount)!), for: .normal)
        
        userFollowingButton.setTitle(String((userData?.getUser.followerCount)!), for: .normal)
        
        let sessionNum: Int = (userData?.getUser.userSession)!
        userSessionLabel.text = sessionData[sessionNum]
        
        containerView.updateHeight(containerViewHeight, (userData?.getUser.pofolCount)!, userData?.getUserBand?.count ?? 0, 0)
        
        guard let imageUrl = userData?.getUser.profileImgUrl else { return }
        if let url = URL(string: imageUrl) {
            userImageView.load(url: url)
            userImageView.contentMode = .scaleAspectFill
        } else {
            userImageView.image = UIImage(named: "default_image")
        }
        userImageView.setRounded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserInfo()
        
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
        
        //appDelegate.otherUserIdx = self.userIdx
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "otherUserEmbed"{
            let containerVC = segue.destination as! OtherTabmanViewController
            
            containerVC.userData = self.userData
            containerVC.userIdx = self.userIdx
        }
    }
    

}
