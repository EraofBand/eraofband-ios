//
//  GetLessonListService.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/28.
//

import Foundation
import Alamofire
import UIKit

class GetLessonListService {
    
    static func getLessonInfoList(_ region: String, _ session: String, completion: @escaping (Bool, LessonListData) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var url = appDelegate.baseUrl + "/lessons/info/list/" + region + "/" + session
        print("url: \(url)")
        
        url = url.encodeUrl()!
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let request = AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header)
        
        request.responseJSON() { response in
            //print(response)
        }
            
        request.responseDecodable(of: LessonListData.self) { response in
            switch response.result {
            case .success(let lessonListData):
                print(lessonListData)
                completion(true, lessonListData)
            case .failure(let err):
                print(err)
            }
        }
        
    }
    
}
