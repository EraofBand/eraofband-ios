//
//  EditViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/12.
//

import Foundation
import UIKit
import PhotosUI
import Alamofire

class EditViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var introduceView: UIView!
    @IBOutlet weak var introduceTextView: UITextView!
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var fileName: String = ""
    
    @IBOutlet weak var birthTextField: UITextField!
    
    private let datePicker = UIDatePicker()
    private var birthDate: Date?
    
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    
    var cityPickerView = UIPickerView()
    var districtPickerView = UIPickerView()
    
    let city = ["서울", "경기"]
    let districtSeoul = ["강서구", "광진구", "강남구"]
    let districtGyeonggi = ["성남시"]
    
    var gender: String = "MALE"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var imgUrl: String = ""
    
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    
    /*레이아웃 구성 함수*/
    func setLayout(){
        /*생년월일 textfield 보더 넣기*/
        birthTextField.layer.borderWidth = 1
        birthTextField.layer.borderColor = UIColor(red: 0.717, green: 0.717, blue: 0.717, alpha: 1).cgColor
        birthTextField.layer.cornerRadius = 5
        
    }
    
    @objc func doneBtnTapped(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        birthTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    /*date picker 만드는 함수*/
    func createDatePicker(_ birth: String){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnTapped))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let birthText = dateFormatter.date(from: birth)!
        
        birthTextField.inputAccessoryView = toolbar
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.maximumDate = Date()
        datePicker.date = birthText
        birthTextField.inputView = datePicker
        
        toolbar.setItems([doneBtn], animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*프로필 편집 기본 유저 정보*/
        GetUserDataService.shared.getUserInfo { (response) in
            switch(response) {
            case .success(let userData):
                /*서버 연동 성공*/
                if let data = userData as? User {
                    let data = data.getUser
                    
                    let imgUrl = data.profileImgUrl
                    if let url = URL(string: imgUrl) {
                        self.profileImageView.load(url: url)
                    } else {
                        self.profileImageView.image = UIImage(named: "default_image")
                    }
                    self.profileImageView.setRounded()
                    
                    self.nickNameTextField.text = data.nickName
                    
                    self.introduceTextView.text = data.introduction
                    
                    let num = (self.introduceTextView.text?.count)!
                    self.textCount.text = "\(num)/50"
                    
                    let userGender = data.gender
                    if userGender == "MALE" {
                        self.maleButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                        self.gender = "MALE"
                    } else {
                        self.femaleButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                        self.gender = "FEMALE"
                    }
                    
                    self.birthTextField.text = data.birth
                    self.createDatePicker(data.birth)
                    
                    let region = data.region.components(separatedBy: " ")
                    self.cityTextField.text = region[0]
                    self.districtTextField.text = region[1]

                }
                
            case .requestErr(let message) :
                print("requestErr", message)
            case .pathErr :
                print("pathErr")
            case .serverErr :
                print("serveErr")
            case .networkFail:
                print("networkFail")
            }
        }
        
        /*프로필 편집 기본 레이아웃*/
        introduceTextView.delegate = self
        
        self.navigationItem.title = "프로필 편집"
        
        introduceView.layer.cornerRadius = 15
        setLayout()
        
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        
        cityTextField.inputView = cityPickerView
        
        districtPickerView.delegate = self
        districtPickerView.dataSource = self
        
        districtTextField.inputView = districtPickerView
        
        saveButton.layer.cornerRadius = 10
        addTapGesture()
        
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        if #available(iOS 14, *){
            pickImage()
        } else {
            openGallery()
        }
        
    }
    
    @IBAction func maleAction(_ sender: Any) {
        maleButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        femaleButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        gender = "MALE"
    }
    
    @IBAction func femaleAction(_ sender: Any) {
        maleButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        femaleButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        gender = "FEMALE"
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        PostUserService.getImgUrl(profileImageView.image) { [self] (isSuccess, result) in
            if isSuccess {
                imgUrl = result
                
                let region: String = cityTextField.text! + " " + districtTextField.text!
                
                let params: Dictionary<String, Any?> = ["birth": birthTextField.text!,
                                                       "gender": gender,
                                                       "introduction": introduceTextView.text,
                                                       "nickName": nickNameTextField.text!,
                                                       "profileImgUrl": imgUrl,
                                                       "region": region,
                                                       "userIdx": appDelegate.userIdx!]
                
                PostUserService.postUserInfo(params) { response in
                    if response {
                        print("어헣ㅎ 잘되네")
                    } else {
                        print("뭐가 문제야")
                    }
                    
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
}

extension EditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        textCount.text = "\(changedText.count)/50"
        
        return changedText.count <= 50
    }
}

extension EditViewController: PHPickerViewControllerDelegate {
    
    func pickImage() {
        let photoLibrary = PHPhotoLibrary.shared()
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        configuration.selectionLimit = 1
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .current
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async { [self] in
                    self.profileImageView.image = image as? UIImage
                    
                    let identifiers = results.compactMap(\.assetIdentifier)
                    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
                    if let filename = fetchResult.firstObject?.value(forKey: "filename") as? String {
                        
                        print("가져온 파일의 이름 : \(filename)")
                        
                        /*
                        var imageData: NSData = self.profileImageView.image!.jpegData(compressionQuality: 0.5)! as NSData
                        var imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
                        print("imageData: \(imageData)")
                        print("imgString: \(imgString)")*/
                        
                    }
            
                }
            }
        }
    }
    
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openGallery(){
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            
            var fileName: String = ""
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset{
                fileName = asset.value(forKey: "filename") as? String ?? ""
                print(fileName)
                self.fileName = fileName
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension EditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension UIImage{
    var base64: String? {
            self.jpegData(compressionQuality: 1)?.base64EncodedString()
        }
}

extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
