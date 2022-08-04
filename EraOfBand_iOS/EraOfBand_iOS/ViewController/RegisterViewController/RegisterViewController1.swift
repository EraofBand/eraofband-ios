//
//  RegisterViewController1.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/04.
//

import UIKit

class RegisterViewController1: UIViewController{
    @IBOutlet weak var backBarBtn: UIBarButtonItem!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var myRegisterData: RegisterData = RegisterData.init(birth: "", gender: "", nickName: "", profileImgUrl: "", region: "", userSession: 0)
    
    @IBAction func backBarBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        myRegisterData.setNickName(newNickName: nicknameTextField.text ?? "")
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController2") as? RegisterViewController2 else {return}
        nextVC.myRegisterData = myRegisterData
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func nicknameOnChanged(_ sender: Any) {
        if((nicknameTextField.text?.trimmingCharacters(in: .whitespaces).count)! > 0){
            nextBtn.isEnabled = true
        }else{
            nextBtn.isEnabled = false
        }
    }
    
    
    func setLayout(){
        let text = welcomeLabel.text
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text! as NSString).range(of: appDelegate.myKakaoData.kakaoUserName))
        
        welcomeLabel.attributedText = attributedString
        
        nextBtn.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeLabel.text = appDelegate.myKakaoData.kakaoUserName + "님" + "\n밴드의 시대에 오신 것을\n진심으로 환영합니다:)"
        
        setLayout()
        nicknameTextField.delegate = self
        
    }
    
}

extension RegisterViewController1: UITextFieldDelegate{
    //화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
    //리턴 버튼 터치시 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // TextField 비활성화
            return true
        }
}
