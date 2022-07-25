//
//  MypageTabView.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/06.
//

import UIKit
import Alamofire

class MypageTabViewController: UIViewController {
    
    // 레이아웃 변수
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var introductionView: UIView!
    @IBOutlet weak var sessionView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tabConerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    // user 정보 변수
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var porfolLabel: UILabel!
    @IBOutlet weak var sessionLabel: UILabel!
    
    
    var userRegion: String = ""
    var userAge: Int = 0
    var userGender: String = ""
    var userPofolCount: Int = 0
    var session: Int = 0
    var sessionData: [String] = ["보컬", "기타", "베이스", "드럼", "키보드"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 프로필 view, 세션 view 모서리 둥글게
        infoView.layer.cornerRadius = 15
        sessionView.layer.cornerRadius = 15
        bottomView.layer.cornerRadius = 15
        containerView.layer.cornerRadius = 15
        tabConerView.layer.cornerRadius = 15
        
        let newSize = introductionLabel.sizeThatFits(introductionView.frame.size)
        introductionLabel.frame.size = newSize
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        backBarButtonItem.tintColor = .white
        
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        GetUserDataService.shared.getUserInfo { [self](response) in
            
            switch(response) {
            case .success(let userData):
                print(userData)
                /*서버 연동 성공*/
                if let data = userData as? User {
                    let data = data.getUser
                    
                    /*마이페이지 유저 정보 입력*/
                    nickNameLabel.text = data.nickName
                    
                    let region = data.region
                    userRegion = region.components(separatedBy: " ")[1]
                    
                    let year = DateFormatter()
                    year.dateFormat = "yyyy"
                    let currentYear = year.string(from: Date())
                    let birthYear = data.birth.components(separatedBy: "-")[0]
                    userAge = Int(currentYear)! - Int(birthYear)! + 1
                    
                    let gender = data.gender
                    if gender == "MALE" {
                        userGender = "남"
                    } else {
                        userGender = "여"
                    }
                    userInfoLabel.text = "\(userRegion) / \(userAge) / \(userGender)"
                    
                    if let introduction = data.introduction {
                        introductionLabel.text = introduction
                    } else {
                        introductionLabel.text = ""
                    }
                    
                    let followeeCount = data.followeeCount
                    let followerCount = data.followerCount
                    followingButton.setTitle(String(followerCount), for: .normal)
                    followerButton.setTitle(String(followeeCount), for: .normal)
                    
                    porfolLabel.text = String(data.pofolCount)
                    
                    let imageUrl = data.profileImgUrl
                    if let url = URL(string: imageUrl) {
                        userImageView.load(url: url)
                    } else {
                        userImageView.image = UIImage(named: "default_image")
                    }
                    userImageView.setRounded()
                    
                    session = data.userSession
                    sessionLabel.text = sessionData[session]
                    
                    containerView.updateHeight(containerViewHeight, data.pofolCount)
                    
                }
                
            case .requestErr(let message) :
                print("requestErr", message)
            case .pathErr :
                print("pathErr")
            case .serverErr :
                print("serveErr")
            case .networkFail:
                print("networkFail")
            }
    
        }
    }
    
    @IBAction func followingBtnTapped(_ sender: Any) {
        
        guard let followVC = storyboard?.instantiateViewController(withIdentifier: "FollowTabManViewController") as? FollowTabManViewController else {return}
        
        followVC.myNickName = nickNameLabel.text
        followVC.currentPage = "Following"
        
        navigationController?.pushViewController(followVC, animated: true)
    }
    @IBAction func followerBtnTapped(_ sender: Any) {
        guard let followVC = storyboard?.instantiateViewController(withIdentifier: "FollowTabManViewController") as? FollowTabManViewController else {return}
        
        followVC.myNickName = nickNameLabel.text
        followVC.currentPage = "Follower"
        
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    
    @IBAction func changeSession(_ sender: Any) {
        
        guard let sessionVC = storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as? SessionViewController else { return }
        
        sessionVC.session = session
        
        self.navigationController?.pushViewController(sessionVC, animated: true)
        
    }
    
}

extension UIImageView {
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIView {
    func updateHeight(_ height: NSLayoutConstraint, _ pofolCount: Int) {
        let cellHeight = self.frame.width / 3 - 2
        
        var containerHeight: CGFloat = 350
        
        if pofolCount > 3 {
            if pofolCount % 3 == 0 {
                containerHeight = cellHeight * CGFloat(pofolCount / 3) + 150
            } else {
                containerHeight = cellHeight * CGFloat(pofolCount / 3 + 1) + 150
            }
        }
        
        height.constant = containerHeight
    }
}
