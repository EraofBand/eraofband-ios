//
//  CheckRegisterService.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/08.
//

import Foundation
import UIKit
import Alamofire

class CheckRegisterService {
    
    // 회원가입 여부 확인 함수
    static func checkRegister(_ kakoToken: String, completion: @escaping (LoginUserData) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/users/login/" + kakoToken
        
        AF.request(url,
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: header).responseDecodable(of: LoginUserData.self) { response in
            switch response.result{
            case .success(let userData):
                print("로그인 성공")
                completion(userData)
            case .failure(let error):
                print("로그인 error: \(error)")
            }
        }
        
    }
    
}
