//
//  AddPofolViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/12.
//

import UIKit
import Alamofire
import Photos
import AVFoundation
import AVKit
import Kingfisher

protocol MediaPickerDelegate: AnyObject {
    func didFinishPickingMedia(videoURL: URL)
}

class AddPofolViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addFileView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var thumbNailImageView: UIImageView!
    
    var currentTitle: String = ""
    var currentThumbNailUrl: String = ""
    var currentDescription: String = ""
    var isModifying: Bool = false
    var pofolIdx: Int = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var imagePicker: UIImagePickerController = {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        imagePicker.mediaTypes = ["public.movie"]
        return imagePicker
    }()
    
    var currentVideoUrl: URL?

    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if isModifying == false{
        PostUserService.getImgUrl(self.thumbNailImageView.image){
            [self] (isSuccess, imgResult) in
            if isSuccess{
                
                PostUserService.getVideoUrl(videoUrl: currentVideoUrl!){
                    (isSuccess, videoResult) in
                    if isSuccess{
 
                        let header : HTTPHeaders = [
                            "x-access-token": self.appDelegate.jwt,
                            "Content-Type": "application/json"]
                        
                        AF.request(self.appDelegate.baseUrl + "/pofols",
                                   method: .post,
                                   parameters: [
                                    "content": self.descriptionTextView.text ?? "",
                                    "imgUrl": imgResult,
                                    "title": self.titleTextField.text ?? "",
                                    "userIdx": self.appDelegate.userIdx!,
                                    "videoUrl": videoResult
                                    ],
                                   encoding: JSONEncoding.default,
                                    headers: header
                        ).responseJSON{ response in
                            print(response)
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            }
        }
        else{
            let header : HTTPHeaders = [
                "x-access-token": self.appDelegate.jwt,
                "Content-Type": "application/json"]
            
            AF.request(self.appDelegate.baseUrl + "/pofols/pofol-info/\(pofolIdx)/",
                       method: .patch,
                       parameters: [
                        "content": self.descriptionTextView.text ?? "",
                        "title": self.titleTextField.text ?? "",
                        "userIdx": self.appDelegate.userIdx!,
                        ],
                       encoding: JSONEncoding.default,
                        headers: header
            ).responseJSON{ response in
                print(response)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        

    }

    @IBAction func addFileBtnTapped(_ sender: Any) {
        if(isModifying == false){
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func setLayout(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 42))
        
        
        if(isModifying == false){
            self.title = "포트폴리오 추가"
        }else{
            self.title = "포트폴리오 수정"
        }
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        titleTextField.borderStyle = .none
        titleTextField.layer.cornerRadius = 15
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "제목",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)]
        )
        titleTextField.delegate = self
        titleTextField.leftView = paddingView
        titleTextField.rightView = paddingView
        titleTextField.leftViewMode = .always
        titleTextField.rightViewMode = .always
        

        addFileView.layer.cornerRadius = 15
        thumbNailImageView.layer.cornerRadius = 15
        
        descriptionTextView.layer.cornerRadius = 15
        descriptionTextView.text = "포트폴리오에 대해 설명해주세요."
        descriptionTextView.textColor = UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)
        descriptionTextView.delegate = self
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        titleTextField.text = currentTitle
        descriptionTextView.text = currentDescription
        
        if(currentThumbNailUrl != ""){
            thumbNailImageView.kf.setImage(with: URL(string: currentThumbNailUrl))
        }
        
        imagePicker.delegate = self
        
    }
}

extension AddPofolViewController: MediaPickerDelegate{
    func didFinishPickingMedia(videoURL: URL) {
        self.thumbNailImageView.image = self.getThumbnailImage(forUrl: videoURL)
        

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let movieUrl = info[.mediaURL] as? URL else {return}
        //guard let movieNSUrl = info[.mediaURL] as? NSURL else {return}
        
        self.currentVideoUrl = movieUrl
        
        //print(movieUrl)
        
        picker.dismiss(animated: true, completion: nil)
        self.didFinishPickingMedia(videoURL: movieUrl)
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        //imageGenerator.maximumSize = CGSize(width: 600, height: 600)
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    

}

extension AddPofolViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1){
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty{
            textView.text = "포트폴리오에 대해 설명해주세요"
            textView.textColor = UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)
        }
    }
    
}

extension AddPofolViewController: UITextFieldDelegate{
    //화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
    //리턴 버튼 터치시 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
}
