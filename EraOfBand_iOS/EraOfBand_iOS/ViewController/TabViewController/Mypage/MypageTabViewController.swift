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
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetUserDataService.shared.getUserInfo { (response) in
            switch(response) {
            case .success(let userData):
                /*서버 연동 성공*/
                print(userData)
                if let data = userData as? User {
                    let data = data.getUser
                    /*마이페이지 유저 정보 입력*/
                    self.nickNameLabel.text = data.nickName

                    let region = data.region
                    self.userRegion = region.components(separatedBy: " ")[1]

                    let year = DateFormatter()
                    year.dateFormat = "yyyy"
                    let currentYear = year.string(from: Date())
                    let birthYear = data.birth.components(separatedBy: "-")[0]
                    self.userAge = Int(currentYear)! - Int(birthYear)! + 1

                    let gender = data.gender
                    if gender == "MALE" {
                        self.userGender = "남"
                    } else {
                        self.userGender = "여"
                    }
                    self.userInfoLabel.text = "\(self.userRegion) / \(self.userAge) / \(self.userGender)"

                    if let introduction = data.introduction {
                        self.introductionLabel.text = introduction
                    } else {
                        self.introductionLabel.text = ""
                    }

                    let followeeCount = data.followeeCount
                    self.followingButton.setTitle(String(followeeCount), for: .normal)
                    /*
                     self.followingButton.titleLabel!.font = UIFont(name: "Pretendard-Bold", size: 40)
                     */

                    let followerCount = data.followerCount
                    self.followerButton.setTitle(String(followerCount), for: .normal)

                    let imageUrl = data.profileImgUrl
                    if let url = URL(string: imageUrl) {
                        self.userImageView.load(url: url)
                    } else {
                        self.userImageView.image = UIImage(named: "default_image")
                    }
                    self.userImageView.setRounded()

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
        
        // 프로필 view, 세션 view 모서리 둥글게
        infoView.layer.cornerRadius = 15
        sessionView.layer.cornerRadius = 15
        bottomView.layer.cornerRadius = 15
        
        scrollView.updateContentSize()
        print(scrollView.contentSize)

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

extension UIScrollView {
    func updateContentSize() {
        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
        
        // 계산된 크기로 컨텐츠 사이즈 설정
        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height+50)
        print(self.contentSize)
    }
    
    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect: CGRect = .zero
        
        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
        for subView in view.subviews {
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }
        
        // 최종 계산 영역의 크기를 반환
        return totalRect.union(view.frame)
    }
}
