//
//  BandRecruitViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/28.
//

import UIKit
import Alamofire
import Kingfisher

class BandRecruitViewController: UIViewController{
    @IBOutlet weak var bandImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    @IBOutlet weak var likeBtnView: UIView!
    @IBOutlet weak var shareBtn: UIButton!
    
    var bandIdx: Int?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var bandInfo: BandInfoResult?
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLayout(){
        likeBtnView.layer.cornerRadius = 10
        shareBtn.layer.cornerRadius = 10
        bandImageView.layer.cornerRadius = 15
    }
    
    func setData(){
        self.title = bandInfo?.bandTitle
        bandImageView.kf.setImage(with: URL(string: bandInfo?.bandImgUrl ?? ""))
        titleLabel.text = bandInfo?.bandTitle
        introductionLabel.text = bandInfo?.bandIntroduction
    }
    
    func getBandInfo(){
        let header : HTTPHeaders = [
            "x-access-token": self.appDelegate.jwt,
            "Content-Type": "application/json"]
        AF.request("\(appDelegate.baseUrl)/sessions/info/\(bandIdx ?? 0)",
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header).responseDecodable(of: BandInfoData.self){ response in
            
                switch response.result{
                case .success(let data):
                    self.bandInfo = data.result!
                    print(self.bandInfo!)
                    self.setData()
                    
                case .failure(let err):
                    print(err)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        getBandInfo()
    }
}
