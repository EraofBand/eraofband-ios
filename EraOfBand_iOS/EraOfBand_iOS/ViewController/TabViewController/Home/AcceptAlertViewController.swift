//
//  AcceptAlertViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/03.
//

import UIKit
import Alamofire

class AcceptAlertViewController: UIViewController {

    @IBOutlet weak var dicisionView: UIView!
    @IBOutlet weak var doneView: UIView!
    @IBOutlet weak var dicisionLabel: UILabel!
    @IBOutlet weak var refuseButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var doneTopLabel: UILabel!
    @IBOutlet weak var doneBottomLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var userNickName: String?
    var userIdx: Int?
    var bandIdx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dicisionView.layer.cornerRadius = 15
        doneView.layer.cornerRadius = 15
        refuseButton.layer.cornerRadius = 15
        acceptButton.layer.cornerRadius = 15
        doneButton.layer.cornerRadius = 15
        
        dicisionLabel.text = "\(userNickName!)님을 선발하시겠습니까?"
        
        refuseButton.addTarget(self, action: #selector(refuseClicked), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptClicked), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneClicked), for: .touchUpInside)
        
    }
    
    @objc func refuseClicked() {
        doneTopLabel.text = "거절 완료"
        doneBottomLabel.text = "거절이 완료되었습니다."
        
        selectMember("out")
        
        dicisionView.isHidden = true
        doneView.isHidden = false
        
    }
    
    @objc func acceptClicked() {
        doneTopLabel.text = "수락 완료"
        doneBottomLabel.text = "이제부터 같은 밴드에 소속됩니다!"
        
        selectMember("in")
        
        dicisionView.isHidden = true
        doneView.isHidden = false
    }
    
    @objc func doneClicked() {
        dismiss(animated: true)
    }
    
    func selectMember(_ decision: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        let url = "\(appDelegate.baseUrl)/sessions/\(decision)/\(bandIdx!)/\(userIdx!)"
        
        AF.request(url,
                   method: .patch,
                   encoding: JSONEncoding.default,
                   headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let err):
                print(err)
            }
            
        }
        
    }

}
