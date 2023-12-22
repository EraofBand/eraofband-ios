//
//  GetOtherUserDataService.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/04.
//

import UIKit
import Alamofire

struct GetOtherUserDataService{
    static let shared = GetOtherUserDataService()
    
    static func getOtherUserInfo(_ userIdx: Int, completion: @escaping (Bool, OtherUserDataModel) -> Void){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let defaults = UserDefaults.standard
        let url = "\(appDelegate.baseUrl)/users/info/\(userIdx)"
        
        let header : HTTPHeaders = [
            "x-access-token": defaults.string(forKey: "jwt")!,
            "Content-Type": "application/json"]
        
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: header
        ).responseDecodable(of: OtherUserDataModel.self){ response in
            switch response.result{
            case .success(let userInfoData):
                print(userInfoData)
                completion(true, userInfoData)
                
            case .failure(let err):
                print(err)
            }
            
        }
    }
    
}
