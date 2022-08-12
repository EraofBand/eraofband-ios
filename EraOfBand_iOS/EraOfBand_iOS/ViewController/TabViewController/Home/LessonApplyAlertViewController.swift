//
//  LessonApplyAlertViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/04.
//

import UIKit
import Alamofire

protocol SendDataDelegate:AnyObject{
    func sendData(lessonInfo: LessonInfoResult)
}

class LessonApplyAlertViewController: UIViewController{
    
    @IBOutlet weak var decisionView: UIView!
    @IBOutlet weak var doneView: UIView!
    @IBOutlet weak var dicisionLabel: UILabel!
    @IBOutlet weak var refuseButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var doneTopLabel: UILabel!
    @IBOutlet weak var doneBottomLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var isMember: Bool = false
    var isFull: Bool = false
    var lessonIdx: Int?
    
    weak var delegate:SendDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        decisionView.layer.cornerRadius = 15
        doneView.layer.cornerRadius = 15
        refuseButton.layer.cornerRadius = 15
        acceptButton.layer.cornerRadius = 15
        doneButton.layer.cornerRadius = 15
        
        if(isFull){
            decisionView.isHidden = true
            doneView.isHidden = false
            doneTopLabel.text = "모집 마감"
            doneBottomLabel.text = "이미 모집이 마감되었습니다!"
        }
        
        if(isMember){
            decisionView.isHidden = true
            doneView.isHidden = false
            doneTopLabel.text = "중복 신청 불가"
            doneBottomLabel.text = "이미 레슨을 수강하고 있습니다!"
        }else{
            dicisionLabel.text = "레슨을 신청하시겠습니까?"
        }
        
        
        refuseButton.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(applyClicked), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneClicked), for: .touchUpInside)
        
    }
    
    @objc func cancelClicked() {
        dismiss(animated: true)
    }
    
    @objc func applyClicked() {
        /*
        doneTopLabel.text = "수락 완료"
        doneBottomLabel.text = "이제부터 같은 밴드에 소속됩니다!"*/
        
        apply()
    }
    
    @objc func doneClicked() {
        let preVC = self.presentingViewController
        
        GetLessonInfoService.getLessonInfo(lessonIdx ?? 0){ [self]
            (isSuccess, response) in
            if isSuccess{
                if let parent = delegate{
                    parent.sendData(lessonInfo: response.result!)
                    dismiss(animated: true)
                }
                
            }
        }
        
    }
    
    func apply(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]

        AF.request("\(appDelegate.baseUrl)/lessons/\(lessonIdx ?? 0)",
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch(response.result){
            case.success:
                self.decisionView.isHidden = true
                self.doneView.isHidden = false
            default:
                return
            }
        }
    }
}
