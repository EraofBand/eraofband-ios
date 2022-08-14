//
//  ChatInfoData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/09.
//

import Foundation

struct chatInfo: Codable {
    
    var message: String
    var readUser: Bool
    var timeStamp: Int
    var userIdx: Int
}

struct userIdxInfo: Codable {
    
    var firstUserIdx: Int
    var secondUserIdx: Int
    
}
