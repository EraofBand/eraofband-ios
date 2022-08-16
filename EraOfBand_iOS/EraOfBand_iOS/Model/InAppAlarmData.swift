//
//  InAppAlarmData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/04.
//

import Foundation

struct InAppAlarmData: Codable {
    
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: [alarmInfo]
    
}

struct alarmInfo: Codable {
    
    var noticeBody: String
    var noticeHead: String
    var noticeIdx: Int
    var noticeImg: String
    var status: String
    var updatedAt: String
    
}
