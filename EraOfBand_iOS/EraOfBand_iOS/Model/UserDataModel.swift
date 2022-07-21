//
//  UserInfoData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/12.
//

import Foundation

// MARK: UserDataModel
struct UserDataModel: Codable {
    var code: Int
    var isSuccess: Bool
    var message: String
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
    var birth: String
    var followeeCount: Int
    var followerCount: Int
    var gender: String
    var introduction: String?
    var nickName: String
    var pofolCount: Int
    var profileImgUrl: String
    var region: String
    var userSession: Int
}


// MARK: 유저 밴드 정보
struct GetUserBand: Codable {
    var bandIdx: Int
    var bandImgUrl: String
    var bandIntroduction: String
    var bandRegion: String
    var bandTitle: String
    var capacity: Int
    var memberCount: Int
}


// MARK: 유저 레슨 정보
struct GetUserLesson: Codable {
    var capacity: Int
    var lessonIdx: Int
    var lessonImgUrl: String
    var lessonIntroduction: String
    var lessonRegion: String
    var lessonTitle: String
    var memberCount: Int
}


// MARK: 유저 포트폴리오 정보
struct GetUserPofol: Codable {
    var imgUrl: String
    var pofolIdx: Int
}

