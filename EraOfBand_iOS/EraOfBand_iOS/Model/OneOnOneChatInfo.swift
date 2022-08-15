//
//  OneOnOneChatInfo.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/15.
//

import Foundation

struct OneOnOneChatInfo: Codable{
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: OneOnOneResult
}

struct OneOnOneResult: Codable{
    var chatRoomIdx: String
    var status: Int
}
