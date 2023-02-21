//
//  GetBandInfoService.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/30.
//

import UIKit
import Alamofire

struct GetBandInfoService{
    static let shared = GetBandInfoService()
    
    static func getBandInfo(_ bandIdx: Int, completion: @escaping (Bool, BandInfoData) -> Void){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let defaults = UserDefaults.standard
        let url = "\(appDelegate.baseUrl)/sessions/info/\(bandIdx)"
        //print(url)
        let header : HTTPHeaders = [
            "x-access-token": defaults.string(forKey: "jwt")!,
            "Content-Type": "application/json"]
        
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: header
        ).responseDecodable(of: BandInfoData.self){ response in
            switch response.result{
            case .success(let bandInfoData):
                print(bandInfoData)
                completion(true, bandInfoData)
                
            case .failure(let err):
                print(err)
            }
            
        }
        
    }
}
