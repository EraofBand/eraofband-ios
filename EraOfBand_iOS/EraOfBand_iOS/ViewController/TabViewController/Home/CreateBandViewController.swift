//
//  CreateBandViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/25.
//

import UIKit

class CreateBandViewController: UIViewController{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var shortIntroTextField: UITextField!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var chatLinkTextField: UITextField!
    @IBOutlet weak var vocalTextField: UITextField!
    @IBOutlet weak var guitarTextField: UITextField!
    @IBOutlet weak var bassTextField: UITextField!
    @IBOutlet weak var keyboardTextField: UITextField!
    @IBOutlet weak var drumTextField: UITextField!
    @IBOutlet weak var vocalNumView: UIView!
    @IBOutlet weak var guitarNumView: UIView!
    @IBOutlet weak var bassNumView: UIView!
    @IBOutlet weak var keyboardNumView: UIView!
    @IBOutlet weak var drumNumView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var titleLengthLabel: UILabel!
    @IBOutlet weak var shortIntroLengthLabel: UILabel!
    @IBOutlet weak var longIntroLengthLabel: UILabel!
    @IBOutlet weak var vocalNumLabel: UILabel!
    @IBOutlet weak var guitarNumLabel: UILabel!
    @IBOutlet weak var bassNumLabel: UILabel!
    @IBOutlet weak var keyboardNumLabel: UILabel!
    @IBOutlet weak var drumNumLabel: UILabel!
    
    let imagePickerController = UIImagePickerController()
    @IBOutlet weak var bandImageView: UIImageView!
    
    let city = ["서울", "경기"]
    let districtSeoul = ["강서구", "광진구", "강남구"]
    
    var cityPickerView = UIPickerView()
    var districtPickerView = UIPickerView()
    
    /*세션 인원 변경 함수*/
    @IBAction func vocalMinusTapped(_ sender: Any) {
        if(Int(vocalNumLabel.text ?? "0")! > 0){
            vocalNumLabel.text = String(Int(vocalNumLabel.text ?? "0")! - 1)
        }
    }
    @IBAction func vocalPlusTapped(_ sender: Any) {
        vocalNumLabel.text = String(Int(vocalNumLabel.text ?? "0")! + 1)
    }
    
    @IBAction func guitarMinusTapped(_ sender: Any) {
        if(Int(guitarNumLabel.text ?? "0")! > 0){
            guitarNumLabel.text = String(Int(guitarNumLabel.text ?? "0")! - 1)
        }
    }
    @IBAction func guitarPlusTapped(_ sender: Any) {
        guitarNumLabel.text = String(Int(guitarNumLabel.text ?? "0")! + 1)
    }
    
    @IBAction func bassMinusTapped(_ sender: Any) {
        if(Int(bassNumLabel.text ?? "0")! > 0){
            bassNumLabel.text = String(Int(bassNumLabel.text ?? "0")! - 1)
        }
    }
    @IBAction func bassPlusTapped(_ sender: Any) {
        bassNumLabel.text = String(Int(bassNumLabel.text ?? "0")! + 1)
    }
    
    @IBAction func keyboardMinusTapped(_ sender: Any) {
        if(Int(keyboardNumLabel.text ?? "0")! > 0){
            keyboardNumLabel.text = String(Int(keyboardNumLabel.text ?? "0")! - 1)
        }
    }
    @IBAction func keyboardPlusTapped(_ sender: Any) {
        keyboardNumLabel.text = String(Int(keyboardNumLabel.text ?? "0")! + 1)
    }
    
    @IBAction func drumMinusTapped(_ sender: Any) {
        if(Int(drumNumLabel.text ?? "0")! > 0){
            drumNumLabel.text = String(Int(drumNumLabel.text ?? "0")! - 1)
        }
    }
    @IBAction func drumPlusTapped(_ sender: Any) {
        drumNumLabel.text = String(Int(drumNumLabel.text ?? "0")! + 1)
    }
    
    /*텍스트필드 카운트*/
    @IBAction func titleOnChanged(_ sender: Any) {
        titleLengthLabel.text = String(titleTextField.text?.count ?? 0) + " / 20"
        
    }
    @IBAction func shortIntroOnChanged(_ sender: Any) {
        shortIntroLengthLabel.text = String(shortIntroTextField.text?.count ?? 0) + " / 20"
    }
    
    @IBAction func addImageBtnTapped(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setLayout(){
        self.title = "밴드 생성"
        
        /*코너 radius 값 조정*/
        titleTextField.borderStyle = .none
        titleTextField.layer.cornerRadius = 15
        shortIntroTextField.borderStyle = .none
        shortIntroTextField.layer.cornerRadius = 15
        chatLinkTextField.borderStyle = .none
        chatLinkTextField.layer.cornerRadius = 15
        vocalTextField.borderStyle = .none
        vocalTextField.layer.cornerRadius = 15
        guitarTextField.borderStyle = .none
        guitarTextField.layer.cornerRadius = 15
        bassTextField.borderStyle = .none
        bassTextField.layer.cornerRadius = 15
        keyboardTextField.borderStyle = .none
        keyboardTextField.layer.cornerRadius = 15
        drumTextField.borderStyle = .none
        drumTextField.layer.cornerRadius = 15
        introTextView.layer.cornerRadius = 15
        
        imageView.layer.cornerRadius = 15
        
        vocalNumView.layer.cornerRadius = 15
        guitarNumView.layer.cornerRadius = 15
        bassNumView.layer.cornerRadius = 15
        keyboardNumView.layer.cornerRadius = 15
        drumNumView.layer.cornerRadius = 15
        
        /*padding 넣어주기*/
        titleTextField.addPadding()
        shortIntroTextField.addPadding()
        chatLinkTextField.addPadding()
        vocalTextField.addPadding()
        guitarTextField.addPadding()
        bassTextField.addPadding()
        keyboardTextField.addPadding()
        drumTextField.addPadding()
        
        introTextView.textContainerInset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        
        cityTextField.inputView = cityPickerView
        
        districtPickerView.delegate = self
        districtPickerView.dataSource = self
        
        districtTextField.inputView = districtPickerView
        
        titleTextField.delegate = self
        shortIntroTextField.delegate = self
        
        imagePickerController.delegate = self
        bandImageView.layer.cornerRadius = 15
        
        introTextView.delegate = self
        introTextView.text = "밴드를 소개해주세요!"
        introTextView.textColor = UIColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1)
    }
}

extension UITextField{
    func addPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        
        self.leftView = paddingView
        self.rightView = paddingView
        self.leftViewMode = ViewMode.always
        self.rightViewMode = ViewMode.always
    }
    
}

/*picker뷰 설정*/
extension CreateBandViewController: UIPickerViewDelegate, UIPickerViewDataSource{
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

/*textfield 글자수 제한*/
extension CreateBandViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 20
    }
}

extension CreateBandViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage]{
            bandImageView.image = (image as! UIImage)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CreateBandViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if introTextView.textColor == UIColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1){
            introTextView.text = nil
            introTextView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if introTextView.text.isEmpty{
            textView.text = "밴드를 소개해주세요!"
            textView.textColor = UIColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        longIntroLengthLabel.text = String(introTextView.text.count) + " / 500"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textViewText = textView.text,
                let rangeOfTextToReplace = Range(range, in: textViewText) else {
                    return false
            }
            let substringToReplace = textViewText[rangeOfTextToReplace]
            let count = textViewText.count - substringToReplace.count + text.count
            return count <= 500
    }
}
