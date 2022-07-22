//
//  PostUserService.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/22.
//

import Foundation
import Alamofire
import UIKit

class PostUserService {
    
    static func getImgUrl(_ image: UIImage?, completion: @escaping (Bool, String) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let urlString = appDelegate.baseUrl + "/api/v1/upload"
        let header : HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            
            let imageData: NSData = image!.jpegData(compressionQuality: 0.50)! as NSData
            
            multipartFormData.append(imageData as Data, withName: "file", fileName: "test.jpg", mimeType: "image/jpg")
            
        }, to: urlString, method: .post, headers: header).responseDecodable(of: ImgUrlModel.self) { response in
            
            guard let imgInfo = response.value else { return }
            print(imgInfo.result)
            
            completion(true, imgInfo.result)
            
        }
        
    }
    
    
    static func getVideoUrl(videoUrl: URL, completion: @escaping (Bool, String) -> Void){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let urlString = appDelegate.baseUrl + "/api/v1/upload"
        let header : HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        print("get video url test")
        print(videoUrl)
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(videoUrl, withName: "file", fileName: "video.mp4", mimeType: "video/mp4")
            
        }, to: urlString, method: .post, headers: header).responseDecodable(of: ImgUrlModel.self) {response in
            
            guard let videoInfo = response.value else {return}
            print(videoInfo.result)
            
            completion(true, videoInfo.result)
        }
        
    }
    
    static func postUserInfo(_ params: Dictionary<String, Any?>, completion: @escaping(Bool) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
        
        AF.request(request).responseString { response in
            switch response.result {
            case .success:
                print("POST 성공")
                completion(true)
            case .failure(let error):
                print(error.errorDescription!)
                completion(false)
            }
            
        }
        
    }
    
    
}
