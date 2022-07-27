//
//  GetFollowService.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/26.
//

import Foundation
import Alamofire
import UIKit

class GetFollowService {
    
    static func getFollowingList(_ userIdx: Int, completion: @escaping (Bool, FollowData) -> Void){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/info/follow/" + String(userIdx),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success(let obj):
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    let getData = try JSONDecoder().decode(FollowData.self, from: dataJSON)
                    
                    print(getData)
                    completion(true, getData)
                    
                }catch{
                    print(error.localizedDescription)
                }
            default:
                return
            }
        }
    }
    
    static func getFollowerList(_ userIdx: Int, completion: @escaping (Bool, FollowData) -> Void){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/info/follow/" + String(userIdx),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success(let obj):
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    let getData = try JSONDecoder().decode(FollowData.self, from: dataJSON)
                    
                    completion(true, getData)
                    
                }catch{
                    print(error.localizedDescription)
                }
            default:
                return
            }
        }
    }
    
    
}
