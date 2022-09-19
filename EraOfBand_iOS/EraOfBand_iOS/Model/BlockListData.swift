//
//  BlockListData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/09/18.
//

import Foundation

struct BlockListData: Codable {
    
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: [blockListInfo]
    
}

struct blockListInfo: Codable {
    
    var nickName: String
    var profileImgUrl: String
    var userIdx: Int
    
}
