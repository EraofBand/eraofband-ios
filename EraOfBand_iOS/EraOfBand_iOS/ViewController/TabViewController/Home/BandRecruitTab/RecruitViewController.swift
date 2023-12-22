//
//  RecruitViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/29.
//

import UIKit
import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon
import SafariServices

class RecruitViewController: UIViewController{

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var applicantView: UIView!
    @IBOutlet weak var applicantTableView: UITableView!
    @IBOutlet weak var recruitTableView: UITableView!
    @IBOutlet weak var line: UIView!
    
    var bandInfo: BandInfoResult?
    var recruitCellCount: Int = 0
    var sessionCount: [Int] = []
    var sessionComment: [String] = []
    var sessionName: [String] = []
    var applicantsInfo: [Applicant] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func setCell() {
        
        if bandInfo!.vocal > 0 {
            sessionCount.append(bandInfo!.vocal)
            sessionComment.append(bandInfo!.vocalComment)
            sessionName.append("보컬")
            recruitCellCount += 1
        }
        if bandInfo!.guitar > 0 {
            sessionCount.append(bandInfo!.guitar)
            sessionComment.append(bandInfo!.guitarComment)
            sessionName.append("기타")
            recruitCellCount += 1
        }
        if bandInfo!.base > 0 {
            sessionCount.append(bandInfo!.base)
            sessionComment.append(bandInfo!.baseComment)
            sessionName.append("베이스")
            recruitCellCount += 1
        }
        if bandInfo!.keyboard > 0 {
            sessionCount.append(bandInfo!.keyboard)
            sessionComment.append(bandInfo!.keyboardComment)
            sessionName.append("키보드")
            recruitCellCount += 1
        }
        if bandInfo!.drum > 0 {
            sessionCount.append(bandInfo!.drum)
            sessionComment.append(bandInfo!.drumComment)
            sessionName.append("드럼")
            recruitCellCount += 1
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setCell()
        
        applicantsInfo = bandInfo!.applicants ?? []
        print(applicantsInfo.count)
        
        applicantTableView.delegate = self
        applicantTableView.dataSource = self
        applicantTableView.alwaysBounceVertical = false
        applicantTableView.register(UINib(nibName: "RecruitHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "RecruitHeaderView")
        applicantTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -40, right: 0)
        
        recruitTableView.isScrollEnabled = false
        recruitTableView.delegate = self
        recruitTableView.dataSource = self
        recruitTableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
        
        if applicantsInfo.count == 0 {
            
            let label = UILabel(frame: applicantView.bounds)
            label.text = "아직 지원자가 존재하지 않습니다"
            label.textColor = .white
            label.font = UIFont(name: "Pretendard-Medium", size: 18)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false

            applicantView.addSubview(label)
            applicantView.frame = CGRect(x: 0, y: 0, width: applicantView.frame.width, height: 180)
            
            label.centerXAnchor.constraint(equalTo: applicantView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: applicantView.centerYAnchor).isActive = true
            
        }
        
        if defaults.integer(forKey: "userIdx") != bandInfo!.userIdx {
            
            applicantView.isHidden = true
            applicantView.height = 0
            
        }
        
    }
}

extension RecruitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == applicantTableView {
            if(bandInfo?.userIdx == defaults.integer(forKey: "userIdx")){
                if applicantsInfo.count > 3 {
                    return 3
                } else {
                    return applicantsInfo.count
                }
            }else{
                return 0
            }
        }
            
        if tableView == recruitTableView {
            return recruitCellCount
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == applicantTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ApplicantsTableViewCell
            //cell.cellDelegate = self
            
            cell.recruitDicision.addTarget(self, action: #selector(acceptButtonTapped(sender:)), for: .touchUpInside)
            
            let session = ["보컬", "기타", "베이스", "키보드", "드럼"]
            
            let applicant = applicantsInfo[indexPath.item]
            
            if let url = URL(string: applicant.profileImgUrl!) {
                cell.applicantImageView.load(url: url)
                cell.applicantImageView.contentMode = .scaleAspectFill
            } else {
                cell.applicantImageView.image = UIImage(named: "default_image")
            }
            
            cell.applicantSession.text = session[applicant.buSession!]
            cell.applicantSession.sizeToFit()
            
            cell.applicantIntro.text = applicant.introduction!
            cell.applicantIntro.sizeToFit()
            
            cell.applicantNickName.text = applicant.nickName!
            cell.applicantNickName.sizeToFit()
            
            cell.updateTimeLabel.text = applicant.updatedAt!
            cell.updateTimeLabel.sizeToFit()
            
            
            cell.selectionStyle = .none
            
            
            return cell
            
        }
        
        if tableView == recruitTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SessionRecruitTableViewCell
            cell.cellDelegate = self
            
            cell.titleLabel.text = "\(bandInfo!.bandTitle!) \(sessionName[indexPath.item]) 모집"
            cell.titleLabel.sizeToFit()
            
            cell.recruitLabel.text = "모집 중"
            cell.recruitLabel.sizeToFit()
            
            cell.sessionLabel.text = sessionName[indexPath.item]
            cell.sessionLabel.sizeToFit()
            
            cell.introLabel.text = sessionComment[indexPath.item]
            cell.introLabel.sizeToFit()
            
            cell.recruitNumLabel.text = "모집인원 \(sessionCount[indexPath.item])"
            cell.recruitNumLabel.sizeToFit()
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == applicantTableView {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RecruitHeaderView") as! RecruitHeaderView
            
            return headerView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == applicantTableView {
            return 80
        }
        if tableView == recruitTableView {
            return 220
        }
        return 0
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == applicantTableView {
            let applicant = applicantsInfo[indexPath.item]
            
            let otherUserVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUser") as! OtherUserViewController
            
            GetOtherUserDataService.getOtherUserInfo(applicant.userIdx ?? 0){ [self]
                (isSuccess, response) in
                if isSuccess{
                    otherUserVC.userData = response.result
                    otherUserVC.userIdx = applicant.userIdx
                    self.navigationController?.pushViewController(otherUserVC, animated: true)
                }
                
            }
        }
    }
    
    @objc func acceptButtonTapped(sender: UIButton) {
        let buttonNum = sender.tag
        let applicantInfo = applicantsInfo[buttonNum]
        
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "AcceptAlert") as? AcceptAlertViewController
        alert?.bandIdx = bandInfo?.bandIdx
        alert?.userIdx = applicantInfo.userIdx
        alert?.userNickName = applicantInfo.nickName
        alert?.modalPresentationStyle = .overCurrentContext
        present(alert!, animated: true)
    }
    
}

extension RecruitViewController: CellButtonDelegate {
    
    //세션 모집 공유하기
    func shareRecruit(recruitTitle: String, recruitDescription: String){
        
        if ShareApi.isKakaoTalkSharingAvailable(){
            
            let appLink = Link(iosExecutionParams: ["second": "vvv"])

            // 해당 appLink를 들고 있을 버튼을 만들어준다.
            let button = Button(title: "앱으로 보기", link: appLink)
            
            // Content는 이제 사진과 함께 글들이 적혀있다.
            let content = Content(title: recruitTitle,
                                  imageUrl: URL(string:bandInfo?.bandImgUrl ?? "")!,
                                  description: recruitDescription,
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
            
            let url = URL(string: "https://www.naver.com")!
            
            let safariViewController = SFSafariViewController(url: url)
            
            DispatchQueue.main.async { [weak self] in
                self?.present(safariViewController, animated: false, completion: nil)
            }
            
        }
         
    }
    
    func shareButtonTapped(recruitTitle: String, recruitDescription: String) {
        print("공유하기 버튼 누름")
        shareRecruit(recruitTitle: recruitTitle, recruitDescription: recruitDescription)
    }
    
    func recruitButtonTapped() {
        
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "SessionRecruitAlert") as? RecruitAlertViewController
        alert?.bandIdx = bandInfo?.bandIdx
        alert?.modalPresentationStyle = .overCurrentContext
        
        if bandInfo?.userIdx == defaults.integer(forKey: "userIdx") {
            alert?.validIdx = 0
        } else {
            alert?.validIdx = 1
        }
        
        present(alert!, animated: true)
        
    }
    
    
}
