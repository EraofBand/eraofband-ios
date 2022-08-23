//
//  CreateBandViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/25.
//

import UIKit
import Alamofire
import Kingfisher

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
    @IBOutlet weak var performTitleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var performPlaceTextField: UITextField!
    @IBOutlet weak var performFeeTextField: UITextField!
    @IBOutlet weak var performTitleLengthLabel: UILabel!
    @IBOutlet weak var performPlaceLengthLabel: UILabel!
    @IBOutlet weak var performFeeLengthLabel: UILabel!
    @IBOutlet weak var performDateView: UIView!
    @IBOutlet weak var performTimeView: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    
    var currentMemberSessionNum: [Int] = [0,0,0,0,0]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    var isModifying: Bool = false
    var bandInfo: BandInfoResult?
    var currentImg: UIImage?
    
    let imagePickerController = UIImagePickerController()
    @IBOutlet weak var bandImageView: UIImageView!
    var imgUrl: String = ""
    
    let city = ["서울", "경기"]
    let districtSeoul = ["종로구","중구","용산구","성동구","광진구","동대문구","중랑구","성북구","강북구","도봉구","노원구","은평구","서대문구","마포구","양천구","강서구","구로구","금천구","영등포구","동작구","관악구","서초구","강남구","송파구","강동구"]
    let districtGyeonggi = ["가평군","고양시","과천시","광명시","광주시","구리시","군포시","남양주시","동두천시","부천시","성남시","수원시","시흥시","안산시","안성시","안양시","양주시","양편군","여주시","연천군","오산시","용인시","의왕시","의정부시","이천시","파주시","평택시","포천시","하남시","화성시",]
    
    var cityPickerView = UIPickerView()
    var districtPickerView = UIPickerView()
    
    @IBAction func tapBackGround(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func tapBackGroundWhenModify(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        
        if(!isModifying){
            PostUserService.getImgUrl(bandImageView.image) { [self] (isSuccess, result) in
                if isSuccess{
                    imgUrl = result
                    
                    let header : HTTPHeaders = [
                        "x-access-token": self.appDelegate.jwt,
                        "Content-Type": "application/json"]
                    
                    AF.request(appDelegate.baseUrl + "/sessions",
                               method: .post,
                               parameters: [
                                "bandContent": introTextView.text ?? "",
                                "bandImgUrl": imgUrl,
                                "bandIntroduction": shortIntroTextField.text ?? "",
                                "bandRegion": "\(cityTextField.text ?? "") \(districtTextField.text ?? "")",
                                "bandTitle": titleTextField.text ?? "",
                                "base": Int(bassNumLabel.text ?? "0") ?? 0,
                                "baseComment": bassTextField.text ?? "",
                                "chatRoomLink": chatLinkTextField.text ?? "",
                                "drum": Int(drumNumLabel.text ?? "0") ?? 0,
                                "drumComment": drumTextField.text ?? "",
                                "guitar": Int(guitarNumLabel.text ?? "0") ?? 0,
                                "guitarComment": guitarTextField.text ?? "",
                                "keyboard": Int(keyboardNumLabel.text ?? "") ?? 0,
                                "keyboardComment": keyboardTextField.text ?? "",
                                "userIdx": appDelegate.userIdx ?? 0,
                                "vocal": Int(vocalNumLabel.text ?? "0") ?? 0,
                                "vocalComment": vocalTextField.text ?? ""
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
                
                print(appDelegate.baseUrl + "/sessions/band-info/" + String(bandInfo?.bandIdx ?? 0))
                
                let header : HTTPHeaders = [
                    "x-access-token": self.appDelegate.jwt,
                    "Content-Type": "application/json"]
                
                AF.request(appDelegate.baseUrl + "/sessions/band-info/" + String(bandInfo?.bandIdx ?? 0),
                           method: .patch,
                           parameters: [
                            "bandContent": introTextView.text ?? "",
                            "bandImgUrl": bandInfo?.bandImgUrl,
                            "bandIntroduction": shortIntroTextField.text ?? "",
                            "bandRegion": "\(cityTextField.text ?? "") \(districtTextField.text ?? "")",
                            "bandTitle": titleTextField.text ?? "",
                            "base": Int(bassNumLabel.text ?? "0") ?? 0,
                            "baseComment": bassTextField.text ?? "",
                            "chatRoomLink": chatLinkTextField.text ?? "",
                            "drum": Int(drumNumLabel.text ?? "0") ?? 0,
                            "drumComment": drumTextField.text ?? "",
                            "guitar": Int(guitarNumLabel.text ?? "0") ?? 0,
                            "guitarComment": guitarTextField.text ?? "",
                            "keyboard": Int(keyboardNumLabel.text ?? "") ?? 0,
                            "keyboardComment": keyboardTextField.text ?? "",
                            "performDate": dateTextField.text ?? "",
                            "performFee": Int(performFeeTextField.text ?? ""),
                            "performLocation": performPlaceTextField.text ?? "",
                            "performTime": timeTextField.text ?? "",
                            "performTitle": performTitleTextField.text ?? "",
                            "userIdx": appDelegate.userIdx ?? 0,
                            "vocal": Int(vocalNumLabel.text ?? "0") ?? 0,
                            "vocalComment": vocalTextField.text ?? ""
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
                            "x-access-token": self.appDelegate.jwt,
                            "Content-Type": "application/json"]
                        
                        AF.request(appDelegate.baseUrl + "/sessions/band-info/" + String(bandInfo?.bandIdx ?? 0),
                                   method: .patch,
                                   parameters: [
                                    "bandContent": introTextView.text ?? "",
                                    "bandImgUrl": imgUrl,
                                    "bandIntroduction": shortIntroTextField.text ?? "",
                                    "bandRegion": "\(cityTextField.text ?? "") \(districtTextField.text ?? "")",
                                    "bandTitle": titleTextField.text ?? "",
                                    "base": Int(bassNumLabel.text ?? "0") ?? 0,
                                    "baseComment": bassTextField.text ?? "",
                                    "chatRoomLink": chatLinkTextField.text ?? "",
                                    "drum": Int(drumNumLabel.text ?? "0") ?? 0,
                                    "drumComment": drumTextField.text ?? "",
                                    "guitar": Int(guitarNumLabel.text ?? "0") ?? 0,
                                    "guitarComment": guitarTextField.text ?? "",
                                    "keyboard": Int(keyboardNumLabel.text ?? "") ?? 0,
                                    "keyboardComment": keyboardTextField.text ?? "",
                                    "performDate": dateTextField.text ?? "",
                                    "performFee": Int(performFeeTextField.text ?? ""),
                                    "performLocation": performPlaceTextField.text ?? "",
                                    "performTime": timeTextField.text ?? "",
                                    "performTitle": performTitleTextField.text ?? "",
                                    "userIdx": appDelegate.userIdx ?? 0,
                                    "vocal": Int(vocalNumLabel.text ?? "0") ?? 0,
                                    "vocalComment": vocalTextField.text ?? ""
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
    
    /*세션 인원 변경 함수*/
    @IBAction func vocalMinusTapped(_ sender: Any) {
        if(isModifying){
            if(Int(vocalNumLabel.text ?? "0")! > currentMemberSessionNum[0] ){
                vocalNumLabel.text = String(Int(vocalNumLabel.text ?? "0")! - 1)
            }
        }else{
            if(Int(vocalNumLabel.text ?? "0")! > 0){
                vocalNumLabel.text = String(Int(vocalNumLabel.text ?? "0")! - 1)
            }
        }
        
    }
    @IBAction func vocalPlusTapped(_ sender: Any) {
        vocalNumLabel.text = String(Int(vocalNumLabel.text ?? "0")! + 1)
    }
    
    @IBAction func guitarMinusTapped(_ sender: Any) {
        if(isModifying){
            if(Int(guitarNumLabel.text ?? "0")! > currentMemberSessionNum[1] ){
                guitarNumLabel.text = String(Int(guitarNumLabel.text ?? "0")! - 1)
            }
        }else{
            if(Int(guitarNumLabel.text ?? "0")! > 0){
                guitarNumLabel.text = String(Int(guitarNumLabel.text ?? "0")! - 1)
            }
        }
    }
    @IBAction func guitarPlusTapped(_ sender: Any) {
        guitarNumLabel.text = String(Int(guitarNumLabel.text ?? "0")! + 1)
    }
    
    @IBAction func bassMinusTapped(_ sender: Any) {
        if(isModifying){
            if(Int(bassNumLabel.text ?? "0")! > currentMemberSessionNum[2] ){
                bassNumLabel.text = String(Int(bassNumLabel.text ?? "0")! - 1)
            }
        }else{
            if(Int(bassNumLabel.text ?? "0")! > 0){
                bassNumLabel.text = String(Int(bassNumLabel.text ?? "0")! - 1)
            }
        }
    }
    @IBAction func bassPlusTapped(_ sender: Any) {
        bassNumLabel.text = String(Int(bassNumLabel.text ?? "0")! + 1)
    }
    
    @IBAction func keyboardMinusTapped(_ sender: Any) {
        if(isModifying){
            if(Int(keyboardNumLabel.text ?? "0")! > currentMemberSessionNum[3] ){
                keyboardNumLabel.text = String(Int(keyboardNumLabel.text ?? "0")! - 1)
            }
        }else{
            if(Int(keyboardNumLabel.text ?? "0")! > 0){
                keyboardNumLabel.text = String(Int(keyboardNumLabel.text ?? "0")! - 1)
            }
        }
    }
    @IBAction func keyboardPlusTapped(_ sender: Any) {
        keyboardNumLabel.text = String(Int(keyboardNumLabel.text ?? "0")! + 1)
    }
    
    @IBAction func drumMinusTapped(_ sender: Any) {
        if(isModifying){
            if(Int(drumNumLabel.text ?? "0")! > currentMemberSessionNum[4] ){
                drumNumLabel.text = String(Int(drumNumLabel.text ?? "0")! - 1)
            }
        }else{
            if(Int(drumNumLabel.text ?? "0")! > 0){
                drumNumLabel.text = String(Int(drumNumLabel.text ?? "0")! - 1)
            }
        }
    }
    @IBAction func drumPlusTapped(_ sender: Any) {
        drumNumLabel.text = String(Int(drumNumLabel.text ?? "0")! + 1)
    }
    
    /*텍스트필드 카운트*/
    @IBAction func performTitleOnChanged(_ sender: Any) {
        performTitleLengthLabel.text = String(performTitleTextField.text?.count ?? 0) + " / 20"
    }
    @IBAction func performLocationOnChanged(_ sender: Any) {
        performPlaceLengthLabel.text = String(performPlaceTextField.text?.count ?? 0) + " / 20"
    }
    @IBAction func performFeeOnChanged(_ sender: Any) {
        performFeeLengthLabel.text = String(performFeeTextField.text?.count ?? 0) + " / 20"
    }
    
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
        if(isModifying){
            self.title = "밴드 수정"
        }else{
            self.title = "밴드 생성"
        }
        
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
        
        if(isModifying){
            performTitleTextField.borderStyle = .none
            performTitleTextField.layer.cornerRadius = 15
            performTitleTextField.addPadding()
            
            performPlaceTextField.borderStyle = .none
            performPlaceTextField.layer.cornerRadius = 15
            performPlaceTextField.addPadding()
            
            performFeeTextField.borderStyle = .none
            performFeeTextField.layer.cornerRadius = 15
            performFeeTextField.addPadding()
            
            performDateView.layer.borderWidth = 1.5
            performDateView.layer.borderColor = UIColor(red: 0.162, green: 0.162, blue: 0.162, alpha: 1).cgColor
            performDateView.layer.cornerRadius = 15
            
            performTimeView.layer.borderWidth = 1.5
            performTimeView.layer.borderColor = UIColor(red: 0.162, green: 0.162, blue: 0.162, alpha: 1).cgColor
            performTimeView.layer.cornerRadius = 15
            
        }
    }
    
    func setModifyData(){
        self.titleTextField.text = self.bandInfo?.bandTitle ?? ""
        self.shortIntroTextField.text = self.bandInfo?.bandIntroduction ?? ""
        
        let region = self.bandInfo?.bandRegion!
        self.cityTextField.text = region!.components(separatedBy: " ")[0]
        self.districtTextField.text = region!.components(separatedBy: " ")[1]
        
        self.bandImageView.kf.setImage(with: URL(string: (self.bandInfo?.bandImgUrl)!))
        
        self.introTextView.text = self.bandInfo?.bandContent
        
        self.chatLinkTextField.text = self.bandInfo?.chatRoomLink
        
        self.vocalNumLabel.text = String((self.bandInfo?.vocal)! + currentMemberSessionNum[0])
        self.vocalTextField.text = self.bandInfo?.vocalComment
        
        self.guitarNumLabel.text = String((self.bandInfo?.guitar)! + currentMemberSessionNum[1])
        self.guitarTextField.text = self.bandInfo?.guitarComment
        
        self.bassNumLabel.text = String((self.bandInfo?.base)! + currentMemberSessionNum[2])
        self.bassTextField.text = self.bandInfo?.baseComment
        
        self.keyboardNumLabel.text = String((self.bandInfo?.keyboard)! + currentMemberSessionNum[3])
        self.keyboardTextField.text = self.bandInfo?.keyboardComment
        
        self.drumNumLabel.text = String((self.bandInfo?.drum)! + currentMemberSessionNum[4])
        self.drumTextField.text = self.bandInfo?.drumComment
        
        self.performPlaceTextField.text = self.bandInfo?.performLocation
        self.performTitleTextField.text = self.bandInfo?.performTitle
        if(self.bandInfo?.performFee! != 0){
            self.performFeeTextField.text = String(self.bandInfo?.performFee ?? 0)
        }
        
        self.dateTextField.text = self.bandInfo?.performDate
        self.timeTextField.text = self.bandInfo?.performTime
        
        
        titleLengthLabel.text = String(bandInfo?.bandTitle?.count ?? 0) + " / 20"
        shortIntroLengthLabel.text = String(bandInfo?.bandIntroduction?.count ?? 0) + " / 20"
        longIntroLengthLabel.text = String(bandInfo?.bandContent?.count ?? 0) + " / 500"
        performTitleLengthLabel.text = String(bandInfo?.performTitle?.count ?? 0) + " / 20"
        performPlaceLengthLabel.text = String(bandInfo?.performLocation?.count ?? 0) + " / 20"
        
        let feeString = String(bandInfo?.performFee ?? 0)
        performFeeLengthLabel.text = String(feeString.count) + " / 20"
    }
    
    @objc func doneBtnTapped(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    /*date picker 만드는 함수*/
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnTapped))
        
        dateTextField.inputAccessoryView = toolbar
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        
        toolbar.setItems([doneBtn], animated: true)
    }
    
    @objc func timeDoneBtnTapped(){
        let dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter_db = DateFormatter()
        dateFormatter_db.dateFormat = dateFormat
        let dateFormatter_eventDate = DateFormatter()
        dateFormatter_eventDate.dateFormat = "a hh:mm" //Your time format
        let date = dateFormatter_db.date(from: timePicker.date.toString())
        
        timeTextField.text = dateFormatter_eventDate.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    func createTimePicker(){
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(timeDoneBtnTapped))
        
        timeTextField.inputAccessoryView = toolbar2
        
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.locale = Locale(identifier: "ko-KR")
        timePicker.datePickerMode = .time
        timeTextField.inputView = timePicker
        
        toolbar2.setItems([doneBtn], animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<((bandInfo?.memberCount ?? 1) - 1){
            switch(bandInfo?.sessionMembers![i].buSession){
            case 0:
                self.currentMemberSessionNum[0] += 1
            case 1:
                self.currentMemberSessionNum[1] += 1
            case 2:
                self.currentMemberSessionNum[2] += 1
            case 3:
                self.currentMemberSessionNum[3] += 1
            case 4:
                self.currentMemberSessionNum[4] += 1
            default:
                break
            }
        }
        print(currentMemberSessionNum)
        
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
        
        if(!isModifying){
            introTextView.textColor = UIColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1)
        }
        
        if(isModifying){
            setModifyData()
            createDatePicker()
            createTimePicker()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy-MM-dd"
            dateTextField.text = dateFormatter.string(from: Date())
            timeTextField.text = "오전 11:00"
            
            self.currentImg = self.bandImageView.image!
            
            self.performTitleTextField.delegate = self
            self.performPlaceTextField.delegate = self
            self.performFeeTextField.delegate = self
        }
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

/*textfield 글자수 제한*/
extension CreateBandViewController: UITextFieldDelegate{
    //화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
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
