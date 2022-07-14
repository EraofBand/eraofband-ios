//
//  EditViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/12.
//

import UIKit
import Alamofire

class EditViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var introduceView: UIView!
    @IBOutlet weak var introduceTextField: UITextField!
    
    
    @IBOutlet weak var birthTextField: UITextField!
    
    private let datePicker = UIDatePicker()
    private var birthDate: Date?
    
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    
    var cityPickerView = UIPickerView()
    var districtPickerView = UIPickerView()
    
    let city = ["서울", "경기"]
    let districtSeoul = ["강서구", "광진구", "강남구"]
    
    @IBAction func cameraButton(_ sender: Any) {
        let alert = UIAlertController(title: "원하는 ",message: "",preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) {
            (action) in self.openLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) {
            (action) in self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func openLibrary(){
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: false, completion: nil)
    }

    func openCamera(){
        imagePicker.sourceType = .camera
        present(imagePicker, animated: false, completion: nil)
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
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        birthTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    /*date picker 만드는 함수*/
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnTapped))
        
        birthTextField.inputAccessoryView = toolbar
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        birthTextField.inputView = datePicker
        
        toolbar.setItems([doneBtn], animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationItem.title = "프로필 변경"
        
        introduceView.layer.cornerRadius = 15
        setLayout()
        createDatePicker()
        
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        
        cityTextField.inputView = cityPickerView
        
        districtPickerView.delegate = self
        districtPickerView.dataSource = self
        
        districtTextField.inputView = districtPickerView
        
    }
    
}

extension EditViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage]{
            profileImageView.image = image as! UIImage
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.setRounded()
        }
        dismiss(animated: true, completion: nil)
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



    

//    /* genderBtns[0] == maleButton, genderBtns[1] == femaleButton */
//    @IBOutlet var genderBtns : [UIButton]!
//
//    @IBAction func chooseGender(_ sender: UIButton) {
//        if myRegisterData.gender == "MALE" {
//            if genderBtns.firstIndex(of: sender) == 1 {
//                genderBtns[1].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//                genderBtns[0].setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
//                myRegisterData.setGender(newGender: "FEMALE")
//            }
//        } else {
//            if genderBtns.firstIndex(of: sender) == 0 {
//                genderBtns[0].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//                genderBtns[1].setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
//                myRegisterData.setGender(newGender: "MALE")
//            }
//        }
//    }

