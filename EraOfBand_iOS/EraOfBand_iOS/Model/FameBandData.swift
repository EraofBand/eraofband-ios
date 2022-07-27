//
//  FameBandData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/26.
//

import Foundation

struct FameBandData: Codable {
    
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: [fameBandInfo]
    
}

struct fameBandInfo: Codable {
    
    var bandIdx: Int
    var bandImgUrl: String
    var bandIntroduction: String
    var bandTitle: String
}
