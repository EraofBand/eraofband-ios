//
//  BandIntroViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/29.
//

import UIKit
import Kingfisher
import SafariServices

class BandIntroViewController: UIViewController{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var leaderProfileImgView: UIImageView!
    @IBOutlet weak var leaderNicknameLabel: UILabel!
    @IBOutlet weak var leaderIntroLabel: UILabel!
    @IBOutlet weak var bandIntroLabel: UILabel!
    @IBOutlet weak var memberView: UIView!
    @IBOutlet weak var nomemberLabel: UILabel!
    @IBOutlet weak var performView: UIView!
    @IBOutlet weak var chatLinkContainerLabel: UIView!
    @IBOutlet weak var chatLinkLabel: UILabel!
    @IBOutlet weak var noperformLabel: UILabel!
    @IBOutlet weak var chatLinkBtn: UIButton!
    @IBOutlet weak var dDayView: UIView!
    @IBOutlet weak var performContentView: UIView!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var performTitleLabel: UILabel!
    @IBOutlet weak var performDateLabel: UILabel!
    @IBOutlet weak var performTimeLabel: UILabel!
    @IBOutlet weak var performLocationLabel: UILabel!
    @IBOutlet weak var performPriceLabel: UILabel!
    @IBOutlet weak var memberTableView: UITableView!
    
    
    var bandInfo: BandInfoResult?
    
    var bandMemberArr: [Int] = []
    
    func setLayout(){
        leaderProfileImgView.layer.cornerRadius = 25
        chatLinkContainerLabel.layer.cornerRadius = 15
    }
    
    //리더 프로필로 이동
    func moveToLeaderProfile(){
        guard let otherUserVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserViewController") as? OtherUserViewController else {return}
        
        GetOtherUserDataService.getOtherUserInfo(bandInfo?.userIdx ?? 0){ [self]
            (isSuccess, response) in
            if isSuccess{
                otherUserVC.userData = response.result
                otherUserVC.userIdx = bandInfo?.userIdx
                self.navigationController?.pushViewController(otherUserVC, animated: true)
            }
            
        }
    }
    
    @IBAction func leaderProfileImgTapped(_ sender: Any) {
        //리더 프사 탭
        moveToLeaderProfile()
    }
    @IBAction func leaderNicknameTapped(_ sender: Any) {
        //리더 닉네임 탭
        moveToLeaderProfile()
    }
    @IBAction func chatLinkBtnTapped(_ sender: Any) {
        var url = bandInfo?.chatRoomLink
        
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
    
    func setData(){
        locationLabel.text = bandInfo?.bandRegion
        
        leaderProfileImgView.kf.setImage(with: URL(string: bandInfo?.profileImgUrl ?? ""))
        leaderNicknameLabel.text = bandInfo?.nickName
        leaderIntroLabel.text = bandInfo?.userIntroduction
        
        bandIntroLabel.text = bandInfo?.bandContent
        
        if(bandInfo?.memberCount == 1){
            memberView.heightAnchor.constraint(equalToConstant: 174).isActive = true
             
            nomemberLabel.text = "아직 멤버가 존재하지 않습니다"
        }else{
            memberView.heightAnchor.constraint(equalToConstant: 80 + CGFloat(80 * ((bandInfo?.memberCount ?? 1) - 1))).isActive = true
        }
        
        if( (bandInfo?.performDate == nil) && (bandInfo?.performLocation == nil) && (bandInfo?.performTime == nil)){
            performView.heightAnchor.constraint(equalToConstant: 174).isActive = true
            
            noperformLabel.text = "공연을 준비중입니다!"
            performContentView.isHidden = true
        }else{
            performView.heightAnchor.constraint(equalToConstant: 192).isActive = true
            
            performContentView.layer.cornerRadius = 15
            dDayView.layer.cornerRadius = 10
            /*디데이 계산하기 추가해야지*/
            
            performTitleLabel.text = self.bandInfo?.performTitle ?? ""
            performTimeLabel.text = self.bandInfo?.performTime ?? ""
            performDateLabel.text = self.bandInfo?.performDate ?? ""
            performLocationLabel.text = self.bandInfo?.performLocation ?? ""
            performPriceLabel.text = String(self.bandInfo?.performFee ?? 0) + "원"
        }
        
        if(bandMemberArr.contains(appDelegate.userIdx!)){
            chatLinkLabel.text = bandInfo?.chatRoomLink
        }else{
            chatLinkLabel.text = "밴드 멤버에게만 공개됩니다"
            chatLinkBtn.isEnabled = false
        }
        //chatLinkLabel.text = bandInfo?.chatRoomLink
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bandMemberArr.append(bandInfo?.userIdx ?? 0)
        for i in 0..<((bandInfo?.memberCount ?? 1) - 1){
            bandMemberArr.append((bandInfo?.sessionMembers![i].userIdx)!)
        }
        
        //print(bandMemberArr)
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
        memberTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setLayout()
        setData()
    }
}

extension BandIntroViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((bandInfo?.memberCount)! - 1)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionMemberTableViewCell", for: indexPath) as! SessionMemberTableViewCell
        
        cell.profileImgView.layer.cornerRadius = 20
        cell.sessionView.layer.cornerRadius = 15
        cell.profileImgView.kf.setImage(with: URL(string: bandInfo?.sessionMembers![indexPath.row].profileImgUrl ?? ""))
        cell.nickNameLabel.text = bandInfo?.sessionMembers![indexPath.row].nickName ?? ""
        cell.introduceLabel.text = bandInfo?.sessionMembers![indexPath.row].introduction ?? ""
        
        var sessionStr = ""
        
        switch(bandInfo?.sessionMembers![indexPath.row].buSession){
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
        
        cell.sessionLabel.text = sessionStr
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let otherUserVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserViewController") as? OtherUserViewController else {return}
        
        GetOtherUserDataService.getOtherUserInfo(bandInfo?.sessionMembers![indexPath.row].userIdx ?? 0){ [self]
            (isSuccess, response) in
            if isSuccess{
                otherUserVC.userData = response.result
                otherUserVC.userIdx = bandInfo?.sessionMembers![indexPath.row].userIdx
                self.navigationController?.pushViewController(otherUserVC, animated: true)
            }
            
        }
    }
}
