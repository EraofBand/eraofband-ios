//
//  MessageListData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/09.
//

import Foundation

struct MessageListData: Codable {
    
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: [messageListInfo]
    
}

struct messageListInfo: Codable {
    
    var chatRoomIdx: String
    var nickName: String
    var profileImgUrl: String
    var status: Int
    
}
