//
//  EraOfBand_iOS++Bundle.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/08.
//

import Foundation

extension Bundle{
    var kakaoKey: String{
        guard let file = self.path(forResource: "ApiKey", ofType: "plist") else {return ""}
        
        guard let resource = NSDictionary(contentsOfFile: file) else {return ""}
        guard let key = resource["KAKAO_KEY"] as? String else {fatalError("ApiKey.plist에 API_KEY설정을 해주세요")}
        return key
    }
}
