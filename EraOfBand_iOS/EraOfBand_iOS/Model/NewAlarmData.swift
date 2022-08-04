//
//  NewAlarmData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/04.
//

import Foundation

struct NewAlarmData: Codable {
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: newAlarm
}

struct newAlarm: Codable {
    var newAlarmExist: Int
}
