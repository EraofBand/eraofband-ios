//
//  CreateLessonViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/26.
//

import UIKit
import Alamofire
import Kingfisher

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
    let defaults = UserDefaults.standard
    var imgUrl: String = ""
    let imagePickerController = UIImagePickerController()
    
    let city = ["서울", "경기"]
    let districtSeoul = ["종로구","중구","용산구","성동구","광진구","동대문구","중랑구","성북구","강북구","도봉구","노원구","은평구","서대문구","마포구","양천구","강서구","구로구","금천구","영등포구","동작구","관악구","서초구","강남구","송파구","강동구"]
    let districtGyeonggi = ["가평군","고양시","과천시","광명시","광주시","구리시","군포시","남양주시","동두천시","부천시","성남시","수원시","시흥시","안산시","안성시","안양시","양주시","양편군","여주시","연천군","오산시","용인시","의왕시","의정부시","이천시","파주시","평택시","포천시","하남시","화성시",]
    let category = ["보컬", "기타", "베이스", "드럼", "키보드"]
    var currentCategory: Int = 0
    
    var cityPickerView = UIPickerView()
    var districtPickerView = UIPickerView()
    var categoryPickerView = UIPickerView()
    
    var isModifying: Bool = false
    var lessonInfo: LessonInfoResult?
    var currentImg: UIImage?
    
    @IBAction func tapBackGround(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func registerBtnTapped(_ sender: Any) {
        
        if(!isModifying){
            PostUserService.getImgUrl(bandImageView.image) { [self] (isSuccess, result) in
                if isSuccess{
                    imgUrl = result
                    
                    let header : HTTPHeaders = [
                        "x-access-token": self.defaults.string(forKey: "jwt")!,
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
                                "userIdx": defaults.integer(forKey: "userIdx")
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
        else{
            if currentImg == self.bandImageView.image{
                
                print("test")
                
                let header : HTTPHeaders = [
                    "x-access-token": self.defaults.string(forKey: "jwt")!,
                    "Content-Type": "application/json"]
                
                AF.request(appDelegate.baseUrl + "/lessons/lesson-info/" + String(lessonInfo?.lessonIdx ?? 0),
                           method: .patch,
                           parameters: [
                            "capacity": Int(numLabel.text ?? "0") ?? 0,
                            "chatRoomLink": chatLinkTextField.text ?? "",
                            "lessonContent": introTextView.text ?? "",
                            "lessonImgUrl": lessonInfo?.lessonImgUrl,
                            "lessonIntroduction": shortIntroTextField.text ?? "",
                            "lessonRegion": "\(cityTextField.text ?? "") \(districtTextField.text ?? "")",
                            "lessonSession": currentCategory,
                            "lessonTitle": titleTextField.text ?? "",
                            "userIdx": defaults.integer(forKey: "userIdx")
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
            }else{
                
                PostUserService.getImgUrl(bandImageView.image) { [self] (isSuccess, result) in
                    if isSuccess{
                        imgUrl = result
                        let header : HTTPHeaders = [
                            "x-access-token": self.defaults.string(forKey: "jwt")!,
                            "Content-Type": "application/json"]
                        
                        AF.request(appDelegate.baseUrl + "/lessons/lesson-info/" + String(lessonInfo?.lessonIdx ?? 0),
                                   method: .patch,
                                   parameters: [
                                    "capacity": Int(numLabel.text ?? "0") ?? 0,
                                    "chatRoomLink": chatLinkTextField.text ?? "",
                                    "lessonContent": introTextView.text ?? "",
                                    "lessonImgUrl": imgUrl,
                                    "lessonIntroduction": shortIntroTextField.text ?? "",
                                    "lessonRegion": "\(cityTextField.text ?? "") \(districtTextField.text ?? "")",
                                    "lessonSession": currentCategory,
                                    "lessonTitle": titleTextField.text ?? "",
                                    "userIdx": defaults.integer(forKey: "userIdx")
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
        }
    }
    
    @IBAction func titleOnChanged(_ sender: Any) {
        titleLengthLabel.text = String(titleTextField.text?.count ?? 0) + " / 20"
    }
    @IBAction func shortIntroOnChanged(_ sender: Any) {
        shortIntroLengthLabel.text = String(shortIntroTextField.text?.count ?? 0) + " / 20"
    }
    
    @IBAction func minusTapped(_ sender: Any) {
        if(isModifying){
            if(Int(numLabel.text ?? "0")! > lessonInfo?.memberCount ?? 0){
                numLabel.text = String(Int(numLabel.text ?? "0")! - 1)
            }
        }else{
            if(Int(numLabel.text ?? "0")! > 0){
                numLabel.text = String(Int(numLabel.text ?? "0")! - 1)
            }
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
    
    func setModifyData(){
        var sessionStr = ""
        
        switch(lessonInfo?.lessonSession){
        case 0:
            sessionStr = "보컬"
        case 1:
            sessionStr = "기타"
        case 2:
            sessionStr = "베이스"
        case 3:
            sessionStr = "드럼"
        case 4:
            sessionStr = "키보드"
        default:
            sessionStr = ""
        }
        categoryTextField.text = sessionStr
        
        titleTextField.text = lessonInfo?.lessonTitle
        shortIntroTextField.text = lessonInfo?.lessonIntroduction
        
        let region = self.lessonInfo?.lessonRegion
        self.cityTextField.text = region!.components(separatedBy: " ")[0]
        self.districtTextField.text = region!.components(separatedBy: " ")[1]
        
        numLabel.text = String(lessonInfo?.capacity ?? 0)
        
        bandImageView.kf.setImage(with: URL(string: lessonInfo?.lessonImgUrl ?? ""))
        
        introTextView.text = lessonInfo?.lessonContent
        
        chatLinkTextField.text = lessonInfo?.chatRoomLink
        
        /*텍스트 길이 정보? 수정*/
        titleLengthLabel.text = String(lessonInfo?.lessonTitle?.count ?? 0) + " / 20"
        shortIntroLengthLabel.text = String(lessonInfo?.lessonIntroduction?.count ?? 0) + " / 20"
        longIntroLengthLabel.text = String(lessonInfo?.lessonContent?.count ?? 0) + " / 500"
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
        
        if(!isModifying){
            introTextView.textColor = UIColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1)
        }
        
        titleTextField.delegate = self
        shortIntroTextField.delegate = self
        
        imagePickerController.delegate = self
        
        isModifying ? setModifyData() : nil
        
        currentImg = bandImageView.image
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
            if(cityTextField.text == "서울"){
                return districtSeoul.count
            }else{
                return districtGyeonggi.count
            }
        }else{
            return category.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPickerView{
            return city[row]
        }else if pickerView == districtPickerView{
            if(cityTextField.text == "서울"){
                return districtSeoul[row]
            }else{
                return districtGyeonggi[row]
            }
        }else{
            return category[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cityPickerView{
            cityTextField.text = city[row]
        }else if pickerView == districtPickerView{
            if(cityTextField.text == "서울"){
                districtTextField.text = districtSeoul[row]
            }else{
                districtTextField.text = districtGyeonggi[row]
            }
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
