//
//  EditViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/12.
//

import UIKit
import PhotosUI
import Alamofire

class EditViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var introduceView: UIView!
    @IBOutlet weak var introduceTextField: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
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
  
    
    func getImgUrl(_ image: UIImage?) {
        
        let urlString = appDelegate.baseUrl + "/api/v1/upload"
        let header : HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in

            let imageData: NSData = image!.jpegData(compressionQuality: 0.50)! as NSData
            let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
            print("imageData: \(imageData)")
            print("imgString: \(imgString)")
            
            multipartFormData.append(imageData as Data, withName: "file", fileName: "test.jpg", mimeType: "image/jpg")

        }, to: urlString, method: .post, headers: header).responseDecodable(of: ImgUrlModel.self) { response in
            
            print(response.value)
            
            guard let imgInfo = response.value else { return }
            print(imgInfo.result)
            self.imgUrl = imgInfo.result
            
        }
        
        
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
                    
                    self.introduceTextField.text = data.introduction
                    
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
        self.navigationItem.title = "프로필 변경"
        self.navigationItem.titleView?.tintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        
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
        
        let region: String = cityTextField.text! + " " + districtTextField.text!
        
        let params: Dictionary<String, Any?> = ["birth": birthTextField.text!,
                                               "gender": gender,
                                               "introduction": introduceTextField.text,
                                               "nickName": nickNameTextField.text!,
                                               "profileImgUrl": imgUrl,
                                               "region": region,
                                               "userIdx": appDelegate.userIdx!]
        
        let urlString = appDelegate.baseUrl + "/users/user-info"
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "PATCH"
        request.headers = header
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("POST 성공")
            case .failure(let error):
                print(error.errorDescription!)
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
                DispatchQueue.main.async {
                    self.profileImageView.image = image as? UIImage
                    
                    self.getImgUrl(self.profileImageView.image)
                    
                    let identifiers = results.compactMap(\.assetIdentifier)
                    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
                    if let filename = fetchResult.firstObject?.value(forKey: "filename") as? String {
                        
                        print("가져온 파일의 이름 : \(filename)")
                        
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
