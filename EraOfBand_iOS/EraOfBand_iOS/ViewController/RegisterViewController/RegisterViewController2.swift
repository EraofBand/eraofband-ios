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
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    var myRegisterData: RegisterData!
    
    var isMale: Bool = false
    var isFemale: Bool = false
    
    let datePicker = UIDatePicker()
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        if(isMale){
            myRegisterData.setGender(newGender: "MALE")
        }else{
            myRegisterData.setGender(newGender: "FEMALE")
        }
        
        myRegisterData.setBirth(newBirth: birthdayTextField.text ?? "")
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController3") as? RegisterViewController3 else {return}
        nextVC.myRegisterData = myRegisterData
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    /*성별 선택 버튼 눌렸을 때*/
    @IBAction func maleBtnTapped(_ sender: Any) {
        maleBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        femaleBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        isMale = true
        isFemale = false
        
        if(!isFemale && !isMale){
            nextBtn.isEnabled = false
        }else{
            nextBtn.isEnabled = true
        }
    }
    
    @IBAction func femaleBtnTapped(_ sender: Any) {
        femaleBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        maleBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        
        isFemale = true
        isMale = false
        
        if(!isFemale && !isMale){
            nextBtn.isEnabled = false
        }else{
            nextBtn.isEnabled = true
        }
    }
    
    /*네비바 뒤로가기 버튼 눌렀을 때*/
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*레이아웃 구성 함수*/
    func setLayout(){
        let text = titleLabel.text
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text! as NSString).range(of: "성별"))
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text! as NSString).range(of: "생년월일"))
        
        titleLabel.attributedText = attributedString
        
        /*생년월일 textfield 보더 넣기*/
        birthdayTextField.layer.borderWidth = 1
        birthdayTextField.layer.borderColor = UIColor(red: 0.717, green: 0.717, blue: 0.717, alpha: 1).cgColor
        birthdayTextField.layer.cornerRadius = 5
        
        nextBtn.isEnabled = false
    }
    
    @objc func doneBtnTapped(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    /*date picker 만드는 함수*/
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnTapped))
        
        birthdayTextField.inputAccessoryView = toolbar
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        birthdayTextField.inputView = datePicker
        
        toolbar.setItems([doneBtn], animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "성별과 생년월일을\n선택해주세요"
        
        setLayout()
        createDatePicker()
        
    }
}
