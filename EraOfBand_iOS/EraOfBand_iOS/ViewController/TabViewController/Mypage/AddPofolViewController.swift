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

protocol MediaPickerDelegate: AnyObject {
    func didFinishPickingMedia(videoURL: URL)
}

class AddPofolViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addFileView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var thumbNailImageView: UIImageView!
    
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

        PostUserService.getVideoUrl(videoUrl: self.currentVideoUrl!) { [self] (isSuccess, result) in
            if isSuccess {
                let header : HTTPHeaders = [
                    "x-access-token": appDelegate.jwt,
                    "Content-Type": "application/json"]
                 
                AF.request(appDelegate.baseUrl + "/pofols",
                           method: .post,
                           parameters: [
                            "content": descriptionTextView.text ?? "",
                            "imgUrl": "",
                            "title": titleTextField.text ?? "",
                            "userIdx": appDelegate.userIdx!,
                            "videoUrl": result
                            ],
                           encoding: JSONEncoding.default,
                            headers: header
                ).responseJSON{ response in
                    switch response.result {
                    case .success:
                        print("POST success")
                    case .failure(let err):
                        print(err)
                    }
                }
                
            }
        }
        
        
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addFileBtnTapped(_ sender: Any) {
        
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    func setLayout(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 42))
        
        self.title = "포트폴리오 추가"
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
        
        imagePicker.delegate = self
    }
}

extension AddPofolViewController: MediaPickerDelegate{
    func didFinishPickingMedia(videoURL: URL) {
        self.thumbNailImageView.image = self.getThumbnailImage(forUrl: videoURL)
        
        self.encodeVideo(at: currentVideoUrl!, completionHandler: nil)
        
        //let nsUrl = NSURL(string: currentVideoUrl!.absoluteString)
        
        //let videoData = NSData(contentsOf: currentVideoUrl!)!
        //PostUserService.getVideoUrl(videoData: videoData)
        
        
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

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    
    func encodeVideo(at videoURL: URL, completionHandler: ((URL?, Error?) -> Void)?)  {
        let avAsset = AVURLAsset(url: videoURL, options: nil)
            
        let startDate = Date()
            
        //Create Export session
        guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
            completionHandler?(nil, nil)
            return
        }
            
        //Creating temp path to save the converted video
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let filePath = documentsDirectory.appendingPathComponent("rendered-Video.mp4")
            
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                completionHandler?(nil, error)
            }
        }
            
        exportSession.outputURL = filePath
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession.timeRange = range
            
        exportSession.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession.status {
            case .failed:
                print(exportSession.error ?? "NO ERROR")
                completionHandler?(nil, exportSession.error)
            case .cancelled:
                print("Export canceled")
                completionHandler?(nil, nil)
            case .completed:
                //Video conversion finished
                let endDate = Date()
                    
                let time = endDate.timeIntervalSince(startDate)
                print(time)
                print("Successful!")
                print("URL 보여줘 : ", exportSession.outputURL ?? "NO OUTPUT URL")
                completionHandler?(exportSession.outputURL, nil)
                
                self.currentVideoUrl = exportSession.outputURL!
                
                default: break
            }
                
        })
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
