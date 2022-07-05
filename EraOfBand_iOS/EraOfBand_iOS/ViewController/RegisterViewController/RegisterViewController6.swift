//
//  RegisterViewController6.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/05.
//

import UIKit

class RegisterViewController6: UIViewController{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var admitBtn1: UIButton!
    @IBOutlet weak var admitBtn2: UIButton!
    @IBOutlet weak var admitAllBtn: UIButton!
    
    var admitBool: [Bool] = [false, false, false]
    
    
    @IBAction func admitAllBtnTapped(_ sender: Any) {
        if admitBool[0] == false{
            admitAllBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            admitBtn1.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            admitBtn2.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }else{
            admitAllBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            admitBtn1.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            admitBtn2.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        
        for i in 0...2{
            admitBool[i] = !admitBool[i]
        }
    }
    
    @IBAction func admitBtn1Tapped(_ sender: Any) {
        if admitBool[1] == false{
            admitBtn1.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else{
            admitBtn1.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        admitBool[1] = !admitBool[1]
    }
    
    @IBAction func admitBtn2Tapped(_ sender: Any) {
        if admitBool[2] == false{
            admitBtn2.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else{
            admitBtn2.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        admitBool[2] = !admitBool[2]
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLayout(){
        
        let text = titleLabel.text
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text! as NSString).range(of: "동의"))
        
        titleLabel.attributedText = attributedString
         
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "서비스 약관에 동의해주세요!"
        
        setLayout()

    }

}

