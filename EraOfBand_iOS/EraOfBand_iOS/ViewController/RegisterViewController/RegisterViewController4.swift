//
//  RegisterViewController4.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/05.
//

import UIKit

class RegisterViewController4: UIViewController{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    
    let city = ["서울", "경기"]
    let districtSeoul = ["강서구", "광진구", "강남구"]
    
    var cityPickerView = UIPickerView()
    var districtPickerView = UIPickerView()
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func setLayout(){
        
        let text = titleLabel.text
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text! as NSString).range(of: "활동 지역"))
        
        titleLabel.attributedText = attributedString
         
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "활동 지역을 선택해주세요"
        
        setLayout()
        
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        
        cityTextField.inputView = cityPickerView
        
        districtPickerView.delegate = self
        districtPickerView.dataSource = self
        
        districtTextField.inputView = districtPickerView
    }
}

extension RegisterViewController4: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == cityPickerView{
            return city.count
        } else{
            return districtSeoul.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPickerView{
            return city[row]
        }else{
            return districtSeoul[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cityPickerView{
            cityTextField.text = city[row]
        }else{
            districtTextField.text = districtSeoul[row]
        }
        
        self.view.endEditing(true)
    }
}
