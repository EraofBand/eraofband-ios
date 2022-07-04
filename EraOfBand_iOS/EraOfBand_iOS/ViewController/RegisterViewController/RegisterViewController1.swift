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
    
    @IBAction func backBarBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setLayout(){
        let text = welcomeLabel.text
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text! as NSString).range(of: "OOO"))
        
        welcomeLabel.attributedText = attributedString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeLabel.text = "OOO님\n밴드의 시대에 오신 것을\n진심으로 환영합니다:)"
        
        setLayout()
    }
}
