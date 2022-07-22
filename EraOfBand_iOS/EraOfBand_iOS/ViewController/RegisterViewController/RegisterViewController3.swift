//
//  RegisterViewController3.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/05.
//

import UIKit

class RegisterViewController3: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    @IBOutlet weak var titleLabel: UILabel!
    var myRegisterData: RegisterData!
    let imagePickerController = UIImagePickerController() //사진앨범 접근을 위해
    @IBOutlet weak var profileImgBorderView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var plusImgView: UIImageView!
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        PostUserService.getImgUrl(profileImgView.image!) { (isSuccess, result) in
            if isSuccess {
                let imgUrl = result
                self.myRegisterData.setProfileImgUrl(newProfileImgUrl: imgUrl)
            }
        }
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController4") as? RegisterViewController4 else {return}
        nextVC.myRegisterData = myRegisterData
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func profileAddBtnTapped(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func setLayout(){
        
        let text = titleLabel.text
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text! as NSString).range(of: "프로필 사진"))
        
        titleLabel.attributedText = attributedString
        
        profileImgBorderView.layer.borderWidth = 3
        profileImgBorderView.layer.borderColor = UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1).cgColor
        profileImgBorderView.layer.cornerRadius = 75
        
        profileImgView.layer.cornerRadius = 75
        
        plusImgView.layer.cornerRadius = 35/2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self

        titleLabel.text = "다른 뮤지션들이\n더 잘 알 수 있도록\n프로필 사진을 선택해주세요"
        
        setLayout()

    }
}

extension RegisterViewController3{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage]{
            profileImgView.image = (image as! UIImage)
        }
        dismiss(animated: true, completion: nil)
    }
}
