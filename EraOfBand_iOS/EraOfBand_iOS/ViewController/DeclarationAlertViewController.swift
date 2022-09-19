//
//  DelarationAlertViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/23.
//

import UIKit
import Alamofire

class DeclarationAlertViewController: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var declareTextView: UITextView!
    @IBOutlet weak var declareView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var declarationButton: UIButton!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    // 0:유저, 1:포폴, 2:포폴 댓글, 3:밴드, 4:레슨, 5:게시물, 6:게시물 댓글
    var reportLocation: Int?
    var reportLocationIdx: Int?
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func declareButtonTapped(_ sender: Any) {
        
        let message = declareTextView.text
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/notice/report"
        let params = ["message": message!, "reportLocation": reportLocation!, "reportLocationIdx": reportLocationIdx!, "userIdx": appDelegate.userIdx!] as Dictionary
        
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: header
        ).response { response in
            switch response.result {
            case .success:
                print("신고 성공")
            case .failure(let err):
                print(err)
            }
        }
        
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.layer.cornerRadius = 15
        declareView.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 10
        declarationButton.layer.cornerRadius = 10
        
        declareTextView.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension DeclarationAlertViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if declareTextView.text == "" {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
    }
}
