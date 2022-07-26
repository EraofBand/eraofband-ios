//
//  NewBandData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/26.
//

import Foundation


struct NewBandData: Codable {
    
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: [topBandData]

}

struct topBandData: Codable {
    
    var bandIdx: Int
    var bandImgUrl: String
    var bandRegion: String
    var bandTitle: String
    var sessionNum: Int
    var totalNum: Int
    
}
