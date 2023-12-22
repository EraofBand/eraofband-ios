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
    
    var myRegisterData: RegisterData!
    
    let city = ["서울", "경기"]
    let districtSeoul = ["종로구","중구","용산구","성동구","광진구","동대문구","중랑구","성북구","강북구","도봉구","노원구","은평구","서대문구","마포구","양천구","강서구","구로구","금천구","영등포구","동작구","관악구","서초구","강남구","송파구","강동구"]
    let districtGyeonggi = ["가평군","고양시","과천시","광명시","광주시","구리시","군포시","남양주시","동두천시","부천시","성남시","수원시","시흥시","안산시","안성시","안양시","양주시","양편군","여주시","연천군","오산시","용인시","의왕시","의정부시","이천시","파주시","평택시","포천시","하남시","화성시",]
    
    var cityPickerView = UIPickerView()
    var districtPickerView = UIPickerView()
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        myRegisterData.setRegion(newRegion: (cityTextField.text ?? "") + " " + (districtTextField.text ?? ""))
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController5") as? RegisterViewController5 else {return}
        nextVC.myRegisterData = myRegisterData
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
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
        
        cityTextField.borderStyle = .none
        districtTextField.borderStyle = .none
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
            if(cityTextField.text == "서울"){
                return districtSeoul.count
            }else{
                return districtGyeonggi.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPickerView{
            return city[row]
        }else{
            if(cityTextField.text == "서울"){
                return districtSeoul[row]
            }else{
                return districtGyeonggi[row]
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cityPickerView{
            cityTextField.text = city[row]
        }else{
            if(cityTextField.text == "서울"){
                districtTextField.text = districtSeoul[row]
            }else{
                districtTextField.text = districtGyeonggi[row]
            }
        }
        
        self.view.endEditing(true)
    }
}
