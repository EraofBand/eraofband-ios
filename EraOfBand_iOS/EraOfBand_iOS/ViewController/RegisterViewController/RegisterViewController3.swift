//
//  RegisterViewController3.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/05.
//

import UIKit

class RegisterViewController3: UIViewController{

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setLayout(){
        
        let text = titleLabel.text
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text! as NSString).range(of: "프로필 사진"))
        
        titleLabel.attributedText = attributedString
         
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "다른 뮤지션들이\n더 잘 알 수 있도록\n프로필 사진을 선택해주세요"
        
        setLayout()
    }
}
