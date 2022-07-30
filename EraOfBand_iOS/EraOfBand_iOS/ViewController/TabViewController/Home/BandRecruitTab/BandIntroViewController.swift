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
    
    var bandInfo: BandInfoResult?
    
    var bandMemberArr: [Int] = []
    
    func setLayout(){
        leaderProfileImgView.layer.cornerRadius = 25
        chatLinkContainerLabel.layer.cornerRadius = 15
    }
    
    @IBAction func chatLinkBtnTapped(_ sender: Any) {
        var url = bandInfo?.chatRoomLink
        
        /*
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:])
            print("test")
        } else {
            UIApplication.shared.openURL(url!)
            print("test2")
        }*/
        
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
        
        if(bandInfo?.memberCount == 0){
            memberView.heightAnchor.constraint(equalToConstant: 174).isActive = true
             
            nomemberLabel.text = "아직 멤버가 존재하지 않습니다"
        }
        
        if(bandInfo?.performDate == nil){
            performView.heightAnchor.constraint(equalToConstant: 174).isActive = true
            
            noperformLabel.text = "공연을 준비중입니다!"
        }
        /*
        if(bandMemberArr.contains(appDelegate.userIdx!)){
            chatLinkLabel.text = bandInfo?.chatRoomLink
        }else{
            chatLinkLabel.text = "밴드 멤버에게만 공개됩니다"
            chatLinkBtn.isEnabled = false
        }*/
        chatLinkLabel.text = bandInfo?.chatRoomLink
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(bandInfo?.memberCount)
        
        for i in 0..<(bandInfo?.memberCount ?? 1){
            print(i)
            print((bandInfo?.sessionMembers![i].userIdx)!)
            bandMemberArr.append((bandInfo?.sessionMembers![i].userIdx)!)
        }
        
        print(bandMemberArr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setLayout()
        setData()
    }
}
