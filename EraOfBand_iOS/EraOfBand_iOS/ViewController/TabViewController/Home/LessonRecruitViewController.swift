//
//  LessonRecruitViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/31.
//

import UIKit
import Kingfisher
import SafariServices
import Alamofire

class LessonRecruitViewController: UIViewController{
    @IBOutlet weak var lessonImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shortIntroLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var lessonTypeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var leaderProfileImgView: UIImageView!
    @IBOutlet weak var leaderNicknameLabel: UILabel!
    @IBOutlet weak var leaderIntroLabel: UILabel!
    @IBOutlet weak var longIntroLabel: UILabel!
    @IBOutlet weak var chatLinkView: UIView!
    @IBOutlet weak var chatLinkLabel: UILabel!
    @IBOutlet weak var chatLinkBtn: UIButton!
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var likeBtnView: UIView!
    @IBOutlet weak var noMemberLabel: UILabel!
    @IBOutlet weak var memberView: UIView!
    
    var lessonIdx: Int?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var lessonInfo: LessonInfoResult?
    
    var lessonMemberArr: [Int] = []
    
    func modifyRecruit(){
        guard let modifyVC = self.storyboard?.instantiateViewController(withIdentifier: "ModifyLessonViewController") as? CreateLessonViewController else {return}
        
        modifyVC.lessonInfo = self.lessonInfo
        modifyVC.isModifying = true
        
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    @IBAction func menuBtnTapped(_ sender: Any) {
        if(lessonInfo?.userIdx == appDelegate.userIdx){
        
            let optionMenu = UIAlertController(title: nil, message: "레슨 모집", preferredStyle: .actionSheet)
            let modifyAction = UIAlertAction(title: "수정하기", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                self.modifyRecruit()
            })
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
                    (alert: UIAlertAction!) -> Void in
                  })
            optionMenu.addAction(cancelAction)
            optionMenu.addAction(modifyAction)
            
        
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
    
    func likeLesson(){
        let header : HTTPHeaders = [
            "x-access-token": self.appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request("\(appDelegate.baseUrl)/lessons/likes/\(lessonIdx ?? 0)",
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch(response.result){
            case.success:
                self.likeIcon.image = UIImage(systemName: "heart.fill")
            default:
                return
            }
        }
    }
    
    func dislikeLesson(){
        let header : HTTPHeaders = [
            "x-access-token": self.appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request("\(appDelegate.baseUrl)/lessons/unlikes/\(lessonIdx ?? 0)",
                   method: .delete,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in

            switch(response.result){
            case.success:
                self.likeIcon.image = UIImage(systemName: "heart")
            default:
                return
            }
        }
    }
    
    @IBAction func likeBtnTapped(_ sender: Any) {
        if(likeIcon.image == UIImage(systemName: "heart")){
            likeLesson()
        }else{
            dislikeLesson()
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func chatLinkTapped(_ sender: Any) {
        var url = lessonInfo?.chatRoomLink
        
        if url!.hasPrefix("http") == true || url!.hasPrefix("https") == true {
            guard let finalURL = URL(string: url!) else {return}
            let safariViewController = SFSafariViewController(url: finalURL)
                        DispatchQueue.main.async { [weak self] in
                            self?.present(safariViewController, animated: false, completion: nil)
                        }
        }else{
            guard let finalURL = URL(string: "http://" + url!) else {return}
            let safariViewController = SFSafariViewController(url: finalURL)
                        DispatchQueue.main.async { [weak self] in
                            self?.present(safariViewController, animated: false, completion: nil)
                        }
        }
    }
    
    func setLayout(){
        self.title = lessonInfo?.lessonTitle ?? ""
        self.lessonImgView.layer.cornerRadius = 15
        likeBtnView.layer.cornerRadius = 10
        shareBtn.layer.cornerRadius = 10
        applyBtn.layer.cornerRadius = 10
        leaderProfileImgView.layer.cornerRadius = 25
        chatLinkView.layer.cornerRadius = 15
        
        if(lessonInfo?.memberCount == 0){
            memberView.heightAnchor.constraint(equalToConstant: 174).isActive = true
            self.noMemberLabel.text = "아직 수강생이 존재하지 않습니다"
        }else{
            memberView.heightAnchor.constraint(equalToConstant: 100 + CGFloat(80 * (lessonInfo?.memberCount ?? 0))).isActive = true
        }
        
        if(lessonInfo?.likeOrNot == "Y"){
            likeIcon.image = UIImage(systemName: "heart.fill")
        }else{
            likeIcon.image = UIImage(systemName: "heart")
        }
    }
    
    func setData(){
        lessonImgView.kf.setImage(with: URL(string: lessonInfo?.lessonImgUrl ?? ""))
        titleLabel.text = lessonInfo?.lessonTitle ?? ""
        shortIntroLabel.text = lessonInfo?.lessonIntroduction
        memberNumLabel.text = String(lessonInfo?.memberCount ?? 0) + " / " + String(lessonInfo?.capacity ?? 0)
        
        var sessionStr = ""
        switch(lessonInfo?.lessonSession){
        case 0:
            sessionStr = "보컬"
        case 1:
            sessionStr = "기타"
        case 2:
            sessionStr = "베이스"
        case 3:
            sessionStr = "드럼"
        case 4:
            sessionStr = "키보드"
        default:
            sessionStr = ""
        }
        
        lessonTypeLabel.text = sessionStr
        locationLabel.text = lessonInfo?.lessonRegion
        leaderProfileImgView.kf.setImage(with: URL(string: lessonInfo?.profileImgUrl ?? ""))
        leaderNicknameLabel.text = lessonInfo?.nickName
        leaderIntroLabel.text = lessonInfo?.userIntroduction
        
        if(lessonMemberArr.contains(appDelegate.userIdx!)){
            chatLinkLabel.text = lessonInfo?.chatRoomLink
        }else{
            chatLinkLabel.text = "수강생에게만 공개됩니다"
            chatLinkBtn.isEnabled = false
        }
        
        longIntroLabel.text = lessonInfo?.lessonContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lessonMemberArr.append(lessonInfo?.userIdx ?? 0)
        for i in 0..<(lessonInfo?.memberCount ?? 1){
            lessonMemberArr.append((lessonInfo?.lessonMembers![i].userIdx)!)
        }
        
        setLayout()
        setData()
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
        memberTableView.separatorStyle = .none
    }
}

extension LessonRecruitViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonInfo?.memberCount ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionMemberTableViewCell", for: indexPath) as! SessionMemberTableViewCell
        
        cell.profileImgView.layer.cornerRadius = 20
        cell.sessionView.layer.cornerRadius = 15
        cell.profileImgView.kf.setImage(with: URL(string: lessonInfo?.lessonMembers![indexPath.row].profileImgUrl ?? ""))
        cell.nickNameLabel.text = lessonInfo?.lessonMembers![indexPath.row].nickName ?? ""
        cell.introduceLabel.text = lessonInfo?.lessonMembers![indexPath.row].introduction ?? ""
        
        var sessionStr = ""
        
        switch(lessonInfo?.lessonMembers![indexPath.row].mySession){
        case 0:
            sessionStr = "보컬"
        case 1:
            sessionStr = "기타"
        case 2:
            sessionStr = "베이스"
        case 3:
            sessionStr = "드럼"
        case 4:
            sessionStr = "키보드"
        default:
            sessionStr = ""
        }
        
        cell.sessionLabel.text = sessionStr
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
