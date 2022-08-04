//
//  RecruitAlertViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/03.
//

import UIKit
import Alamofire

class RecruitAlertViewController: UIViewController {

    @IBOutlet weak var doneView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var recruitButton: UIButton!
    @IBOutlet weak var doneTopLabel: UILabel!
    @IBOutlet weak var doneBottomLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var bandIdx: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertView.layer.cornerRadius = 15
        doneView.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = 15
        recruitButton.layer.cornerRadius = 15
        doneButton.layer.cornerRadius = 15
        
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        recruitButton.addTarget(self, action: #selector(recruitTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneTapped() {
        dismiss(animated: true)
    }
    
    @objc func recruitTapped() {
        
        recruitBand(){ [self] in
            alertView.isHidden = true
            doneView.isHidden = false
        }
        
    }
    
    func recruitBand(completion: @escaping ()-> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = "\(appDelegate.baseUrl)/sessions/\(bandIdx!)"
        let parameters: [String: Int] = ["buSession": 0]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                completion()
            case .failure(let err):
                print(err)
            }
            
        }
    }

}
