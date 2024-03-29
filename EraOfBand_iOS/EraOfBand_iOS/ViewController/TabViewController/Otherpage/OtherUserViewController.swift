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
    let defaults = UserDefaults.standard

    var sessionData: [String] = ["보컬", "기타", "베이스", "키보드", "드럼"]

    var userData: OtherUser?
    
    var chatListData: [messageListInfo] = [] //내 채팅 리스트
    let chatReference = Database.database().reference()
    
    var blockCheck: Int = 0
    
    /* 서버에서 채팅방 정보 리스트 가져오는 함수 */
    func getMessageList(completion: @escaping () -> Void) {
        
        let header : HTTPHeaders = ["x-access-token": defaults.string(forKey: "jwt")!,
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
    
    func getBlockList() {
        let header : HTTPHeaders = ["x-access-token": defaults.string(forKey: "jwt")!,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/users/info/block"
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: BlockListData.self){ response in
            
            switch response.result{
            case .success(let blockListData):
                self.blockCheck = self.checkBlocked(blockListData.result)
            case .failure(let err):
                print(err)
            }
            
        }
    }
    
    /*유저 차단 여부 확인 함수*/
    func checkBlocked(_ blockList: [blockListInfo]) -> Int {
        
        for info in blockList {
            if info.userIdx == userIdx {
                if info.blockChecked == 1 {
                    return 1
                } else {
                    return 0
                }
            }
        }
        return 0
    }
    
    @IBAction func messageBtnTapped(_ sender: Any) {
        
        let header : HTTPHeaders = ["x-access-token": defaults.string(forKey: "jwt")!,
                                    "Content-Type": "application/json"]
        
        AF.request(self.appDelegate.baseUrl + "/chat/chat-room/exist",
                   method: .patch,
                   parameters: [
                    "firstUserIdx": defaults.integer(forKey: "userIdx"),
                    "secondUserIdx": userData?.getUser.userIdx
                   ],
                   encoding: JSONEncoding.default,
                   headers: header).responseDecodable(of: OneOnOneChatInfo.self){ response in
            switch response.result{
            case .success(let oneOneOneInfo):
                print("데이터: \(oneOneOneInfo.result)")
                let result = oneOneOneInfo.result
                
                if(result.chatRoomIdx == "null"){
                    let messageVC = ChatViewController()
                    messageVC.otherUserInfo = self.userData?.getUser
                    self.navigationController?.pushViewController(messageVC, animated: true)
                }
                else{
                    self.chatRoomIdx = result.chatRoomIdx
                    if(result.status == 0){
                        AF.request(self.appDelegate.baseUrl + "/chat/status/active",
                                   method: .patch,
                                   parameters: [
                                    "chatRoomIdx": self.chatRoomIdx,
                                    "firstUserIdx": self.defaults.integer(forKey: "userIdx"),
                                    "secondUserIdx": self.userData?.getUser.userIdx
                                   ],
                                   encoding: JSONEncoding.default,
                                   headers: header).responseJSON{ response in
                            switch response.result{
                            case .success:
                                let messageVC = ChatViewController()
                                messageVC.chatRoomIdx = self.chatRoomIdx
                                messageVC.otherUserInfo = self.userData?.getUser
                                self.navigationController?.pushViewController(messageVC, animated: true)
                            case .failure(let err):
                                print(err)
                            }
                        }
                    }else{
                        let messageVC = ChatViewController()
                        messageVC.chatRoomIdx = self.chatRoomIdx
                        messageVC.otherUserInfo = self.userData?.getUser
                        self.navigationController?.pushViewController(messageVC, animated: true)
                    }
                }
            case .failure(let err):
                print(err)
            }
            
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
    
    @IBAction func moreBtnTapped(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        if blockCheck == 0 {
            let block = UIAlertAction(title: "차단하기", style: .default) { _ in
                self.blockCheck = 1
                self.doBlock()
            }
            
            actionSheet.addAction(block)
        } else {
            let unBlock = UIAlertAction(title: "차단해제", style: .default) { _ in
                self.blockCheck = 0
                self.doUnBlock()
            }
            
            actionSheet.addAction(unBlock)
        }
        
        
        let declare = UIAlertAction(title: "신고하기", style: .destructive) {_ in
            let declareVC = self.storyboard?.instantiateViewController(withIdentifier: "DeclartionAlert") as! DeclarationAlertViewController
            
            declareVC.reportLocation = 0
            declareVC.reportLocationIdx = self.userData?.getUser.userIdx
            declareVC.modalPresentationStyle = .overCurrentContext
            
            self.present(declareVC, animated: true)
        }
        
        actionSheet.addAction(declare)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func doUnBlock() {
        let header : HTTPHeaders = [
            "x-access-token": defaults.string(forKey: "jwt")!,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/unblock/" + String(userIdx!),
                   method: .delete,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON { response in
            switch response.result{
            case .success:
                print("차단 해제 성공")
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func doBlock() {
        let header : HTTPHeaders = [
            "x-access-token": defaults.string(forKey: "jwt")!,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/block/" + String(userIdx!),
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON { response in
            switch response.result{
            case .success:
                print("차단 성공")
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func doUnFollow(){
        let header : HTTPHeaders = [
            "x-access-token": defaults.string(forKey: "jwt")!,
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
            "x-access-token": defaults.string(forKey: "jwt")!,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/follow/" + String(userIdx!),
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success:
                self.followButton.setTitle("언팔로우", for: .normal)
                self.followButton.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.1333333333, blue: 0.1568627451, alpha: 1)
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
            followButton.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.1333333333, blue: 0.1568627451, alpha: 1)
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
        getBlockList()
        
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
        messageButton.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.1333333333, blue: 0.1568627451, alpha: 1)
        messageButton.tintColor = #colorLiteral(red: 0.7675942779, green: 0.7675942779, blue: 0.7675942779, alpha: 1)
        
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
