//
//  LessonInfoData.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/31.
//

import Foundation

struct LessonInfoData: Codable{
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: LessonInfoResult?
}

struct LessonInfoResult: Codable{
    var capacity: Int?
    var chatRoomLink: String?
    var lessonContent: String?
    var lessonIdx: Int?
    var lessonImgUrl: String?
    var lessonIntroduction: String?
    var lessonLikeCount: Int?
    var lessonMembers: [LessonMember]?
    var lessonRegion: String?
    var lessonSession: Int?
    var lessonTitle: String?
    var likeOrNot: String?
    var memberCount: Int?
    var nickName: String?
    var profileImgUrl: String?
    var token: String?
    var userIdx: Int?
    var userIntroduction: String?
}

struct LessonMember: Codable{
    var introduction: String?
    var mySession: Int?
    var nickName: String?
    var profileImgUrl: String?
    var userIdx: Int?
}
