//
//  BandIntroViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/29.
//

import UIKit
import Kingfisher

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
    
    func setLayout(){
        leaderProfileImgView.layer.cornerRadius = 25
        chatLinkContainerLabel.layer.cornerRadius = 15
    }
    
    func setData(){
        locationLabel.text = appDelegate.currentBandInfo?.bandRegion
        
        leaderProfileImgView.kf.setImage(with: URL(string: appDelegate.currentBandInfo?.profileImgUrl ?? ""))
        leaderNicknameLabel.text = appDelegate.currentBandInfo?.nickName
        leaderIntroLabel.text = appDelegate.currentBandInfo?.userIntroduction
        
        bandIntroLabel.text = appDelegate.currentBandInfo?.bandContent
        
        if(appDelegate.currentBandInfo?.memberCount == 0){
            memberView.heightAnchor.constraint(equalToConstant: 174).isActive = true
             
            nomemberLabel.text = "아직 멤버가 존재하지 않습니다"
        }
        
        if(appDelegate.currentBandInfo?.performDate == nil){
            performView.heightAnchor.constraint(equalToConstant: 174).isActive = true
            
            noperformLabel.text = "공연을 준비중입니다!"
        }
        
        chatLinkLabel.text = appDelegate.currentBandInfo?.chatRoomLink
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
}
