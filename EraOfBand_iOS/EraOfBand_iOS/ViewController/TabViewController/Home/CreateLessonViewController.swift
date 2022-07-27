//
//  CreateLessonViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/26.
//

import UIKit
import Alamofire

class CreateLessonViewController: UIViewController{
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var shortIntroTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var chatLinkTextField: UITextField!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var titleLengthLabel: UILabel!
    @IBOutlet weak var shortIntroLengthLabel: UILabel!
    @IBOutlet weak var longIntroLengthLabel: UILabel!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var bandImageView: UIImageView!
    @IBOutlet weak var peopleNumView: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var imgUrl: String = ""
    let imagePickerController = UIImagePickerController()
    
    let city = ["서울", "경기"]
    let districtSeoul = ["강서구", "광진구", "강남구"]
    let category = ["보컬", "기타", "베이스", "드럼", "키보드"]
    var currentCategory: Int = 0
    
    var cityPickerView = UIPickerView()
    var districtPickerView = UIPickerView()
    var categoryPickerView = UIPickerView()
    
    
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        PostUserService.getImgUrl(bandImageView.image) { [self] (isSuccess, result) in
            if isSuccess{
                imgUrl = result
                
                let header : HTTPHeaders = [
                    "x-access-token": self.appDelegate.jwt,
                    "Content-Type": "application/json"]
                
                AF.request(appDelegate.baseUrl + "/lessons",
                           method: .post,
                           parameters: [
                            "capacity": Int(numLabel.text ?? "0") ?? 0,
                            "chatRoomLink": chatLinkTextField.text ?? "",
                            "lessonContent": introTextView.text ?? "",
                            "lessonImgUrl": imgUrl,
                            "lessonIntroduction": shortIntroTextField.text ?? "",
                            "lessonRegion": "\(cityTextField.text ?? "") \(districtTextField.text ?? "")",
                            "lessonSession": currentCategory,
                            "lessonTitle": titleTextField.text ?? "",
                            "userIdx": appDelegate.userIdx ?? 0
                           ],
                           encoding: JSONEncoding.default,
                           headers: header).responseJSON{ response in
                    switch response.result{
                    case .success:
                        self.navigationController?.popViewController(animated: true)
                        print(response)
                    default:
                    return
                }
            }
            
            }
        }
    }
    
    @IBAction func titleOnChanged(_ sender: Any) {
        titleLengthLabel.text = String(titleTextField.text?.count ?? 0) + " / 20"
    }
    @IBAction func shortIntroOnChanged(_ sender: Any) {
        shortIntroLengthLabel.text = String(shortIntroTextField.text?.count ?? 0) + " / 20"
    }
    
    @IBAction func minusTapped(_ sender: Any) {
        if(Int(numLabel.text ?? "0")! > 0){
            numLabel.text = String(Int(numLabel.text ?? "0")! - 1)
        }
    }
    @IBAction func plusTapped(_ sender: Any) {
        numLabel.text = String(Int(numLabel.text ?? "0")! + 1)
    }
    
    @IBAction func addImageBtnTapped(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLayout(){
        self.title = "레슨 생성"
        
        titleTextField.borderStyle = .none
        titleTextField.layer.cornerRadius = 15
        shortIntroTextField.borderStyle = .none
        shortIntroTextField.layer.cornerRadius = 15
        chatLinkTextField.borderStyle = .none
        chatLinkTextField.layer.cornerRadius = 15
        introTextView.layer.cornerRadius = 15
        imageView.layer.cornerRadius = 15
        bandImageView.layer.cornerRadius = 15
        peopleNumView.layer.cornerRadius = 15
        
        titleTextField.addPadding()
        shortIntroTextField.addPadding()
        chatLinkTextField.addPadding()
        
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
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        categoryTextField.inputView = categoryPickerView
        
        introTextView.delegate = self
        introTextView.text = "레슨을 소개해주세요!"
        introTextView.textColor = UIColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1)
        
        titleTextField.delegate = self
        shortIntroTextField.delegate = self
        
        imagePickerController.delegate = self
    }
}

/*picker뷰 설정*/
extension CreateLessonViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == cityPickerView{
            return city.count
        } else if pickerView == districtPickerView{
            return districtSeoul.count
        }else{
            return category.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPickerView{
            return city[row]
        }else if pickerView == districtPickerView{
            return districtSeoul[row]
        }else{
            return category[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cityPickerView{
            cityTextField.text = city[row]
        }else if pickerView == districtPickerView{
            districtTextField.text = districtSeoul[row]
        }else{
            categoryTextField.text = category[row]
            currentCategory = row
        }
        
        self.view.endEditing(true)
    }
}

/*textfield 글자수 제한*/
extension CreateLessonViewController: UITextFieldDelegate{
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

extension CreateLessonViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage]{
            bandImageView.image = (image as! UIImage)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CreateLessonViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if introTextView.textColor == UIColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1){
            introTextView.text = nil
            introTextView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if introTextView.text.isEmpty{
            textView.text = "레슨을 소개해주세요!"
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
