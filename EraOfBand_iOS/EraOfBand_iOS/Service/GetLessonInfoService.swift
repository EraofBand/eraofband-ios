//
//  GetLessonInfoService.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/31.
//

import UIKit
import Alamofire

struct GetLessonInfoService{
    static let shared = GetBandInfoService()
    
    static func getLessonInfo(_ lessonIdx: Int, completion: @escaping (Bool, LessonInfoData) -> Void){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let defaults = UserDefaults.standard
        let url = "\(appDelegate.baseUrl)/lessons/info/\(lessonIdx)"
        let header : HTTPHeaders = ["x-access-token": defaults.string(forKey: "jwt")!,
                                    "Content-Type": "application/json"]
        
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: header
        ).responseDecodable(of: LessonInfoData.self){ response in
            
            switch response.result{
            case .success(let lessonInfoData):
                //print(lessonInfoData)
                completion(true, lessonInfoData)
                
            case .failure(let err):
                print(err)
            }
            
        }
    }
}
