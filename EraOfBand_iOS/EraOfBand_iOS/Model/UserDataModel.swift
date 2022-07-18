//
//  UserInfoData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/12.
//

import Foundation

// MARK: UserDataModel
struct UserDataModel: Codable {
    var code: Int = 0
    var isSuccess: Bool = true
    var message: String = ""
    var result: User
}


// MARK: User
struct User: Codable {
    var getUser: GetUser
    var getUserBand: [GetUserBand]?
    var getUserLesson: [GetUserLesson]?
    var getUserPofol: [GetUserPofol]?
}


// MARK: 유저 기본 정보
struct GetUser: Codable {
    var birth: String = ""
    var followeeCount: Int = 0
    var followerCount: Int = 0
    var gender: String = ""
    var introduction: String?
    var nickName: String = ""
    var pofolCount: Int = 0
    var profileImgUrl: String = ""
    var region: String = ""
    var session: Int = 0
}


// MARK: 유저 밴드 정보
struct GetUserBand: Codable {
    var bandIdx: Int = 0
    var bandImgUrl: String = ""
    var bandIntroduction: String = ""
    var bandRegion: String = ""
    var bandTitle: String = ""
}


// MARK: 유저 레슨 정보
struct GetUserLesson: Codable {
    var lessonIdx: Int = 0
    var lessonImgUrl: String = ""
    var lessonIntroduction: String = ""
    var lessonRegion: String = ""
    var lessonTitle: String = ""
}


// MARK: 유저 포트폴리오 정보
struct GetUserPofol: Codable {
    var imgUrl: String = ""
    var pofolIdx: Int = 0
}
