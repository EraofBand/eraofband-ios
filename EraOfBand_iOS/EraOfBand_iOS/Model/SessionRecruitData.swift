//
//  SessionRecruitData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/03.
//

import Foundation

struct SessionRecruitData: Codable{
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: index
}

struct index: Codable{
    var bandUserIdx: Int
}
