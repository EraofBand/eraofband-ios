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
    @IBOutlet weak var sessionView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    // user 정보 변수
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var porfolLabel: UILabel!
    @IBOutlet weak var sessionLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let userIdx: String = "32"
    
    var userRegion: String = ""
    var userAge: Int = 0
    var userGender: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
        AF.request(appDelegate.baseUrl + "/users/" + userIdx,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: header)
        .responseDecodable(of: UserInfoData.self) { response in
            
            print(response.value)
            
            guard let data = response.data else { return }
            guard let userInfo = try? JSONDecoder().decode(UserInfoData.self, from: data) else { return }
            
            /*마이페이지 유저 정보 입력*/
            self.nickNameLabel.text = userInfo.nickName
            
            guard let region = userInfo.region else { return }
            self.userRegion = region.components(separatedBy: " ")[1]
            
            let year = DateFormatter()
            year.dateFormat = "yyyy"
            let currentYear = year.string(from: Date())
            let birthYear = userInfo.birth.components(separatedBy: "-")[0]
            self.userAge = Int(currentYear)! - Int(birthYear)! + 1
            
            guard let gender = userInfo.gender else { return }
            if gender == "MALE" {
                self.userGender = "남"
            } else {
                self.userGender = "여"
            }
            self.userInfoLabel.text = "\(self.userRegion) / \(self.userAge) / \(self.userGender)"
            
            if let introduction = userInfo.introduction {
                self.introductionLabel.text = introduction
            } else {
                self.introductionLabel.text = ""
            }
            
            if let followeeCount = userInfo.followeeCount {
                self.followingButton.setTitle(String(followeeCount), for: .normal)
                /*
                 self.followingButton.titleLabel!.font = UIFont(name: "Pretendard-Bold", size: 40)
                */
            } else { return }
            
            if let followerCount = userInfo.followerCount {
                self.followerButton.setTitle(String(followerCount), for: .normal)
            } else { return }
            
            if let imageUrl = userInfo.profileImgUrl {
                let url = URL(string: imageUrl)
                self.userImageView.load(url: url!)
                self.userImageView.setRounded()
            }
            
        }
        
        // 프로필 view, 세션 view 모서리 둥글게
        infoView.layer.cornerRadius = 15
        sessionView.layer.cornerRadius = 15
        bottomView.layer.cornerRadius = 15
        
        
        

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
