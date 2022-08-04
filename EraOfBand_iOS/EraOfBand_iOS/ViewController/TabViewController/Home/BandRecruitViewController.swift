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
    
    
    @IBOutlet weak var containerView: UIView!
    var bandInfo: BandInfoResult?
    
    func modifyRecruit(){
        guard let modifyVC = self.storyboard?.instantiateViewController(withIdentifier: "ModifyBandViewController") as? CreateBandViewController else {return}
        
        modifyVC.bandInfo = self.bandInfo
        modifyVC.isModifying = true
        
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    @IBAction func menuBtnTapped(_ sender: Any) {
        
        if(bandInfo?.userIdx == appDelegate.userIdx){
        
            let optionMenu = UIAlertController(title: nil, message: "밴드 모집", preferredStyle: .actionSheet)
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
        
        containerView.heightAnchor.constraint(equalToConstant: 900 + CGFloat(bandInfo?.memberCount ?? 0) * 80).isActive = true
        
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
}
