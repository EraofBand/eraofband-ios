//
//  SearchUserData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/05.
//

import Foundation

struct SearchUserData: Codable {
    
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: [userResultInfo]
    
}

struct userResultInfo: Codable {
    var nickName: String
    var profileImgUrl: String
    var userIdx: Int
    var userSession: Int
}
