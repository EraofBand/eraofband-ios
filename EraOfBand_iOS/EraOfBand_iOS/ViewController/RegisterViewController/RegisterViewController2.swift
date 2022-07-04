//
//  RegisterViewController2.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/04.
//

import UIKit

class RegisterViewController2: UIViewController{
    @IBOutlet weak var backBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    
    @IBAction func maleBtnTapped(_ sender: Any) {
        maleBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        femaleBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    }
    @IBAction func femaleBtnTapped(_ sender: Any) {
        femaleBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        maleBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setLayout(){
        let text = titleLabel.text
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text! as NSString).range(of: "성별"))
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text! as NSString).range(of: "생년월일"))
        
        titleLabel.attributedText = attributedString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "성별과 생년월일을\n선택해주세요"
        
        setLayout()
    }
}
