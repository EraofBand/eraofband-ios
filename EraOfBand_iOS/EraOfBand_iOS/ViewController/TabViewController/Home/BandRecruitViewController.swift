//
//  BandRecruitViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/28.
//

import UIKit
import Alamofire
import Kingfisher
import SafariServices

class BandRecruitViewController: UIViewController{
    @IBOutlet weak var bandImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    @IBOutlet weak var likeBtnView: UIView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var likeIcon: UIImageView!
    
    var bandIdx: Int?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var bandMemberArr: [Int] = []
    
    var header : HTTPHeaders?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    var bandInfo: BandInfoResult?
    
    var recruitCellCount = 0
    
    func modifyRecruit(){
        guard let modifyVC = self.storyboard?.instantiateViewController(withIdentifier: "ModifyBandViewController") as? CreateBandViewController else {return}
        
        modifyVC.bandInfo = self.bandInfo
        modifyVC.isModifying = true
        
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    func deleteBand(){
        AF.request("\(appDelegate.baseUrl)/sessions/status/\(bandIdx ?? 0)",
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
    
    func quitBand(){
        AF.request("\(appDelegate.baseUrl)/sessions/out/\(bandIdx ?? 0)",
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
    
    @IBAction func menuBtnTapped(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(cancelAction)
        
        if(bandInfo?.userIdx == appDelegate.userIdx){
            let modifyAction = UIAlertAction(title: "수정하기", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.modifyRecruit()
            })
            let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                self.deleteBand()
            })
            
            optionMenu.addAction(modifyAction)
            optionMenu.addAction(deleteAction)
            
        }else if(bandMemberArr.contains(appDelegate.userIdx!)){
            let quitAction = UIAlertAction(title: "탈퇴하기", style: .destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                self.quitBand()
            })
            let declareAction = UIAlertAction(title: "신고하기", style: .destructive) {_ in
                let declareVC = self.storyboard?.instantiateViewController(withIdentifier: "DeclartionAlert") as! DeclarationAlertViewController
                
                declareVC.reportLocation = 3
                declareVC.reportLocationIdx = self.bandInfo?.bandIdx
                declareVC.modalPresentationStyle = .overCurrentContext
                
                self.present(declareVC, animated: true)
            }
            
            optionMenu.addAction(quitAction)
            optionMenu.addAction(declareAction)
        } else {
            let declareAction = UIAlertAction(title: "신고하기", style: .destructive) {_ in
                let declareVC = self.storyboard?.instantiateViewController(withIdentifier: "DeclartionAlert") as! DeclarationAlertViewController
                
                declareVC.reportLocation = 3
                declareVC.reportLocationIdx = self.bandInfo?.bandIdx
                declareVC.modalPresentationStyle = .overCurrentContext
                
                self.present(declareVC, animated: true)
            }
            
            optionMenu.addAction(declareAction)
        }
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func likeSession(){
        let header : HTTPHeaders = [
            "x-access-token": self.appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request("\(appDelegate.baseUrl)/sessions/likes/\(bandIdx ?? 0)",
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
    
    func dislikeSession(){
        let header : HTTPHeaders = [
            "x-access-token": self.appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request("\(appDelegate.baseUrl)/sessions/unlikes/\(bandIdx ?? 0)",
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
            likeSession()
        }else{
            dislikeSession()
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLayout(){
        //self.view.translatesAutoresizingMaskIntoConstraints = false
        
        likeBtnView.layer.cornerRadius = 10
        shareBtn.layer.cornerRadius = 10
        bandImageView.layer.cornerRadius = 15
        
        if(bandInfo?.likeOrNot == "N"){
            likeIcon.image = UIImage(systemName: "heart")
        }else{
            likeIcon.image = UIImage(systemName: "heart.fill")
        }
        
        //containerView.heightAnchor.constraint(equalToConstant: 900 + CGFloat((bandInfo?.memberCount ?? 1) - 1) * 80).isActive = true
        
    }
    
    func setData(){
        self.title = bandInfo?.bandTitle
        bandImageView.kf.setImage(with: URL(string: bandInfo?.bandImgUrl ?? ""))
        titleLabel.text = bandInfo?.bandTitle
        introductionLabel.text = bandInfo?.bandIntroduction
        
        memberNumLabel.text = "\(bandInfo?.memberCount ?? 0) / \(bandInfo?.capacity ?? 0)명"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header = [
            "x-access-token": self.appDelegate.jwt,
            "Content-Type": "application/json"]
        
        
        bandMemberArr.append(bandInfo?.userIdx ?? 0)
        for i in 0..<((bandInfo?.memberCount ?? 1) - 1){
            bandMemberArr.append((bandInfo?.sessionMembers![i].userIdx)!)
        }
        
        setLayout()
        setData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        GetBandInfoService.getBandInfo((bandInfo?.bandIdx)!){ [self]
            (isSuccess, response) in
            if isSuccess{
                bandInfo = response.result
                setLayout()
                setData()
                
                countRecruitCell()
                let introHeight = 900 + (bandInfo?.memberCount ?? 1 - 1) * 80
                var recruitHeight = 0
                
                if(bandInfo?.userIdx == appDelegate.userIdx){
                    recruitHeight = (bandInfo?.applicants?.count ?? 1 * 100) + (recruitCellCount * 220) + 350
                }else{
                    recruitHeight = (recruitCellCount * 220) + 300
                }
                
                let heightArr = [introHeight, recruitHeight]
                
                containerViewHeight.constant =  CGFloat(heightArr.max() ?? 1000)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "bandRecruitEmbed"{
            let containerVC = segue.destination as!BandRecruitTabmanViewController
            
            containerVC.bandInfo = self.bandInfo
        }
        
    }
    
    /*세션 모집 셀 개수 세기*/
    func countRecruitCell(){
        recruitCellCount = 0
        
        if bandInfo!.vocal > 0 {
            recruitCellCount += 1
        }
        if bandInfo!.guitar > 0 {
            recruitCellCount += 1
        }
        if bandInfo!.base > 0 {
            recruitCellCount += 1
        }
        if bandInfo!.keyboard > 0 {
            recruitCellCount += 1
        }
        if bandInfo!.drum > 0 {
            recruitCellCount += 1
        }
    }
}
