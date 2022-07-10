//
//  KakaoData.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/09.
//

import Foundation

struct kakaoData{
    var kakaoToken: String
    var kakaoUserName: String
    
    init(kakaoToken: String, kakaoUserName: String){
        self.kakaoToken = kakaoToken
        self.kakaoUserName = kakaoUserName
    }
}
