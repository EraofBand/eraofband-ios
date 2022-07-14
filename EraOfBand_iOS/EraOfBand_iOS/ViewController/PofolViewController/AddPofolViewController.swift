//
//  AddPofolViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/12.
//

import UIKit
import Alamofire

class AddPofolViewController: UIViewController{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addFileView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        //authorizeJWT()
        
        
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
         
        /*
        let header: HTTPHeaders = [.authorization(bearerToken: <#T##String#>), .contentType("application/json")]
        */
         
        AF.request(appDelegate.baseUrl + "/pofol",
                   method: .post,
                   parameters: [
                    "content": descriptionTextView.text ?? "",
                    "imgUrl": "",
                    "title": titleTextField.text ?? "",
                    "userIdx": 36,
                    "videoUrl": ""
                    ],
                   encoding: JSONEncoding.default,
                    headers: header
        ).responseJSON{ response in
            print(response)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    /*
    func authorizeJWT(){
        var request = URLRequest(url: URL(string: appDelegate.baseUrl + "/pofol")!)
        request.addValue("Bearer\(appDelegate.jwt)", forHTTPHeaderField: "Authorization")
    }*/
    
    func setLayout(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 42))
        
        self.title = "포트폴리오 추가"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        titleTextField.borderStyle = .none
        titleTextField.layer.cornerRadius = 15
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "제목",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)]
        )
        titleTextField.delegate = self
        titleTextField.leftView = paddingView
        titleTextField.rightView = paddingView
        titleTextField.leftViewMode = .always
        titleTextField.rightViewMode = .always
        
        addFileView.layer.cornerRadius = 15
        
        
        descriptionTextView.layer.cornerRadius = 15
        descriptionTextView.text = "포트폴리오에 대해 설명해주세요."
        descriptionTextView.textColor = UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)
        descriptionTextView.delegate = self
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
    }
}

extension AddPofolViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1){
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty{
            textView.text = "포트폴리오에 대해 설명해주세요"
            textView.textColor = UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)
        }
    }
    
}

extension AddPofolViewController: UITextFieldDelegate{
    //화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
    //리턴 버튼 터치시 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
}
