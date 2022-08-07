//
//  LessonListData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/28.
//

import Foundation

struct LessonListData: Codable {
    
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: [lessonInfo]
    
}

struct lessonInfo: Codable {
    
    var capacity: Int
    var lessonIdx: Int
    var lessonImgUrl: String
    var lessonIntroduction: String
    var lessonRegion: String
    var lessonTitle: String
    var memberCount: Int
    
}
