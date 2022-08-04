//
//  GetBandListService.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/27.
//

import Foundation
import Alamofire
import UIKit

class GetBandListService {
    
    static func getBandInfoList(_ region: String, _ session: String, completion: @escaping (Bool, BandListData) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var url = appDelegate.baseUrl + "/sessions/info/list/" + region + "/" + session
        print("url: \(url)")
        
        url = url.encodeUrl()!
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let request = AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header)
        
        request.responseJSON() { response in
            print(response)
        }
            
        request.responseDecodable(of: BandListData.self) { response in
            switch response.result {
            case .success(let bandListData):
                print(bandListData)
                completion(true, bandListData)
            case .failure(let err):
                print(err)
            }
        }
        
    }
    
}
