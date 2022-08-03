//
//  RecruitViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/29.
//

import UIKit

class RecruitViewController: UIViewController{

    @IBOutlet weak var applicantView: UIView!
    @IBOutlet weak var applicantTableView: UITableView!
    @IBOutlet weak var recruitTableView: UITableView!
    @IBOutlet weak var moreApplicantButton: UIButton!
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
        
        recruitTableView.delegate = self
        recruitTableView.dataSource = self
        
        if applicantsInfo.count == 0 {
            
            moreApplicantButton.isHidden = true
            
            let label = UILabel(frame: applicantView.bounds)
            label.text = "아직 지원자가 존재하지 않습니다"
            label.textColor = .white
            label.font = UIFont(name: "Pretendard-Medium", size: 18)
            label.textAlignment = .center
            
            applicantView.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: applicantView.centerXAnchor)
            ])
            
            
        }
        
        if appDelegate.userIdx != bandInfo!.userIdx {
            line.isHidden = true
            applicantView.isHidden = true
            applicantView.height = 0
        }
        
    }
}

extension RecruitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == applicantTableView {
            if applicantsInfo.count > 3 {
                return 3
            } else {
                return applicantsInfo.count
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
            
            let session = ["보컬", "기타", "베이스", "키보드", "드럼"]
            
            let applicant = applicantsInfo[indexPath.item]
            cell.applicantImageView.load(url: URL(string: applicant.profileImgUrl!)!)
            
            cell.applicantSession.text = session[applicant.buSession!]
            cell.applicantSession.sizeToFit()
            
            cell.applicantIntro.text = applicant.introduction!
            cell.applicantIntro.sizeToFit()
            
            cell.applicantNickName.text = applicant.nickName!
            cell.applicantNickName.sizeToFit()
            
            cell.updateTimeLabel.text = applicant.updatedAt!
            cell.updateTimeLabel.sizeToFit()
            
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
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == applicantTableView {
            return 100
        }
        if tableView == recruitTableView {
            return 220
        }
        return 0
    
    }
    
}

extension RecruitViewController: CellButtonDelegate {
    func shareButtonTapped() {
        print("공유하기 버튼 누름")
    }
    
    func recruitButtonTapped() {
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "SessionRecruitAlert") as? RecruitAlertViewController
        alert?.bandIdx = bandInfo?.bandIdx
        alert?.modalPresentationStyle = .overCurrentContext
        present(alert!, animated: true)
    }
}
