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
import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon

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
    @IBOutlet weak var memberViewHeight: NSLayoutConstraint!
    
    var lessonIdx: Int?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var lessonInfo: LessonInfoResult?
    
    var lessonMemberArr: [Int] = []
    
    var header : HTTPHeaders?
    
    @IBAction func applyBtnTapped(_ sender: Any) {
        
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "LessonApplyAlertViewController") as? LessonApplyAlertViewController
        if(lessonMemberArr.contains(appDelegate.userIdx!)){
            alert?.isMember = true
        }
        if(lessonInfo?.capacity ?? 0 <= lessonInfo?.memberCount ?? 0){
            alert?.isFull = true
        }
        alert?.lessonIdx = self.lessonIdx
        alert?.modalPresentationStyle = .overFullScreen
        
        alert?.delegate = self
        present(alert!, animated: true)
        
    }
    /*수정 버튼 눌렀을 때*/
    func modifyRecruit(){
        guard let modifyVC = self.storyboard?.instantiateViewController(withIdentifier: "ModifyLessonViewController") as? CreateLessonViewController else {return}
        
        modifyVC.lessonInfo = self.lessonInfo
        modifyVC.isModifying = true
        
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    func quitLesson(){
        
        AF.request("\(appDelegate.baseUrl)/lessons/out/\(lessonIdx ?? 0)",
                   method: .delete,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch(response.result){
            case.success:
                self.navigationController?.popViewController(animated: true)
            default:
                return
            }
        }
    }
    
    func deleteLesson(){
        AF.request("\(appDelegate.baseUrl)/lessons/status/\(lessonIdx ?? 0)",
                   method: .patch,
                   parameters: [
                    "userIdx": appDelegate.userIdx
                   ],
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch(response.result){
            case.success:
                self.navigationController?.popViewController(animated: true)
            default:
                return
            }
        }
    }
    
    func moveToLeaderProfile(){
        guard let otherUserVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserViewController") as? OtherUserViewController else {return}
        
        GetOtherUserDataService.getOtherUserInfo(lessonInfo?.userIdx ?? 0){ [self]
            (isSuccess, response) in
            if isSuccess{
                otherUserVC.userData = response.result
                otherUserVC.userIdx = lessonInfo?.userIdx
                self.navigationController?.pushViewController(otherUserVC, animated: true)
            }
            
        }
    }
    @IBAction func leaderProfileImgTapped(_ sender: Any) {
        moveToLeaderProfile()
    }
    @IBAction func leaderNicknameTapped(_ sender: Any) {
        moveToLeaderProfile()
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        if ShareApi.isKakaoTalkSharingAvailable(){
            
            // Web Link로 전송이 된다. 하지만 우리는 앱 링크를 받을거기 때문에 딱히 필요가 없으.
            // 아래 줄을 주석해도 상관없다.
            
//            let link = Link(webUrl: URL(string:"https://www.naver.com/"),
//            mobileWebUrl: URL(string:"https://www.naver.com/"))
            
            // 우리가 원하는 앱으로 보내주는 링크이다.
            // second, vvv는 url 링크 마지막에 딸려서 오기 때문에, 이 파라미터를 바탕으로 파싱해서
            // 앱단에서 원하는 기능을 만들어서 실행할 수 있다 예를 들면 다른 뷰 페이지로 이동 등등~
            let appLink = Link(iosExecutionParams: ["second": "vvv"])

            // 해당 appLink를 들고 있을 버튼을 만들어준다.
            let button = Button(title: "앱으로 보기", link: appLink)
            
            // Content는 이제 사진과 함께 글들이 적혀있다.
            let content = Content(title: (lessonInfo?.lessonTitle)!,
                                  imageUrl: URL(string:(lessonInfo?.lessonImgUrl)!)!,
                                  description: lessonInfo?.lessonIntroduction,
                                link: appLink)
            
            // 템플릿에 버튼을 추가할때 아래 buttons에 배열의 형태로 넣어준다.
            // 만약 버튼을 하나 더 추가하려면 버튼 변수를 만들고 [button, button2] 이런 식으로 진행하면 된다 .
            let template = FeedTemplate(content: content, buttons: [button])
            
            //메시지 템플릿 encode
            if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
                
                //생성한 메시지 템플릿 객체를 jsonObject로 변환
                if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                    ShareApi.shared.shareDefault(templateObject:templateJsonObject) {(linkResult, error) in
                        if let error = error {
                            print("error : \(error)")
                        }
                        else {
                            print("defaultLink(templateObject:templateJsonObject) success.")
                            guard let linkResult = linkResult else { return }
                            UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
        else {
            print("카카오톡 미설치")
            // 카카오톡 미설치: 웹 공유 사용 권장
            // 아래 함수는 따로 구현해야함.
            
        }
        
    }
    
    /*우측 상단 메뉴 버튼 눌렀을 때*/
    @IBAction func menuBtnTapped(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "레슨 모집", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
              })
        
        optionMenu.addAction(cancelAction)
        
        if(lessonInfo?.userIdx == appDelegate.userIdx){
            let modifyAction = UIAlertAction(title: "수정하기", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                self.modifyRecruit()
            })
            let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive, handler: {
                    (alert: UIAlertAction!) -> Void in
                self.deleteLesson()
            })
            
            optionMenu.addAction(modifyAction)
            optionMenu.addAction(deleteAction)
            
        }else if(lessonMemberArr.contains(appDelegate.userIdx!)){
            let quitAction = UIAlertAction(title: "탈퇴하기", style: .destructive, handler: {
                    (alert: UIAlertAction!) -> Void in
                self.quitLesson()
            })
            let declareAction = UIAlertAction(title: "신고하기", style: .destructive) {_ in
                let declareVC = self.storyboard?.instantiateViewController(withIdentifier: "DeclartionAlert") as! DeclarationAlertViewController
                
                declareVC.reportLocation = 4
                declareVC.reportLocationIdx = self.lessonInfo?.lessonIdx
                declareVC.modalPresentationStyle = .overCurrentContext
                
                self.present(declareVC, animated: true)
            }
            optionMenu.addAction(quitAction)
            optionMenu.addAction(declareAction)
            
        } else {
            let declareAction = UIAlertAction(title: "신고하기", style: .destructive) {_ in
                let declareVC = self.storyboard?.instantiateViewController(withIdentifier: "DeclartionAlert") as! DeclarationAlertViewController
                
                declareVC.reportLocation = 4
                declareVC.reportLocationIdx = self.lessonInfo?.lessonIdx
                declareVC.modalPresentationStyle = .overCurrentContext
                
                self.present(declareVC, animated: true)
            }
            optionMenu.addAction(declareAction)
        }
        
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    /*좋아요 처리*/
    func likeLesson(){
        
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
    
    /*좋아요 취소*/
    func dislikeLesson(){
        
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
    
    /*좋아요 버튼 눌렀을 때*/
    @IBAction func likeBtnTapped(_ sender: Any) {
        if(likeIcon.image == UIImage(systemName: "heart")){
            likeLesson()
        }else{
            dislikeLesson()
        }
    }
    
    /*좌측상단 뒤로가기 버튼*/
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*채팅방 링크 눌렀을 때*/
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
            memberViewHeight.constant = 174
            self.noMemberLabel.text = "아직 수강생이 존재하지 않습니다"
        }else{
            self.noMemberLabel.isHidden = true
            memberViewHeight.constant = 80 + CGFloat(80 * (lessonInfo?.memberCount ?? 0))
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
            sessionStr = "키보드"
        case 4:
            sessionStr = "드럼"
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
            //applyBtn.isEnabled = false
        }else{
            chatLinkLabel.text = "수강생에게만 공개됩니다"
            //chatLinkBtn.isEnabled = false
        }
        
        longIntroLabel.text = lessonInfo?.lessonContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header = [
            "x-access-token": self.appDelegate.jwt,
            "Content-Type": "application/json"]
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //print("뷰윌어피어")
        //print(lessonInfo)
        
        /*
        GetLessonInfoService.getLessonInfo((lessonInfo?.lessonIdx!)!){ [self]
            (isSuccess, response) in
            if isSuccess{
                //print("test")
                lessonInfo = response.result
                viewDidLoad()
            }
        }*/
        //print("테스트")
        //viewDidLoad()
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
        
        cell.selectionStyle = .none
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let otherUserVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserViewController") as? OtherUserViewController else {return}
        
        GetOtherUserDataService.getOtherUserInfo(lessonInfo?.lessonMembers![indexPath.row].userIdx ?? 0){ [self]
            (isSuccess, response) in
            if isSuccess{
                otherUserVC.userData = response.result
                otherUserVC.userIdx = lessonInfo?.lessonMembers![indexPath.row].userIdx
                self.navigationController?.pushViewController(otherUserVC, animated: true)
            }
            
        }
        
    }
}

extension LessonRecruitViewController: SendDataDelegate{
    func sendData(lessonInfo: LessonInfoResult) {
        self.lessonInfo = lessonInfo
        viewDidLoad()
        self.memberTableView.reloadData()
        print("test")
    }
}
