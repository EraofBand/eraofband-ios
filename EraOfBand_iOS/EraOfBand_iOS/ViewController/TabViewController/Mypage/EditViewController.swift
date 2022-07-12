//
//  EditViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/12.
//

import UIKit

class EditViewController: UIViewController {
    
    var myRegisterData: RegisterData!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var introduceView: UIView!
    @IBOutlet weak var introduceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationItem.title = "프로필 변경"
        
        introduceView.layer.cornerRadius = 15
        
        if myRegisterData.gender == "MALE" {
            genderBtns[0].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            genderBtns[1].setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        } else {
            genderBtns[1].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            genderBtns[0].setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        
    }
    
    /* genderBtns[0] == maleButton, genderBtns[1] == femaleButton */
    @IBOutlet var genderBtns : [UIButton]!
    
    @IBAction func chooseGender(_ sender: UIButton) {
        if myRegisterData.gender == "MALE" {
            if genderBtns.firstIndex(of: sender) == 1 {
                genderBtns[1].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                genderBtns[0].setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                myRegisterData.setGender(newGender: "FEMALE")
            }
        } else {
            if genderBtns.firstIndex(of: sender) == 0 {
                genderBtns[0].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                genderBtns[1].setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                myRegisterData.setGender(newGender: "MALE")
            }
        }
    }

}
