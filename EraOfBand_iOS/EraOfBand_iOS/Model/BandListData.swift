//
//  BandListData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/27.
//

import Foundation

struct BandListData: Codable {
    
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: [bandInfo]
    
}

struct bandInfo: Codable {
    
    var bandIdx: Int
    var bandImgUrl: String
    var bandIntroduction: String
    var bandRegion: String
    var bandTitle: String
    var capacity: Int
    var memberCount: Int
    
}
