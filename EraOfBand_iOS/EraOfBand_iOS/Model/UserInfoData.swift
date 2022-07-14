//
//  UserInfoData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/12.
//

import Foundation

struct UserInfoData {
    enum CodingKeys: String, CodingKey {
        case cade
        case isSuccess
        case message
        case result
    }
    enum InfoKeys: String, CodingKey {
        case birth
        case followeeCount
        case followerCount
        case gender
        case introduction
        case nickName
        case pofolCount
        case profileImgUrl
        case region
        case session
        case userIdx
    }
    var birth: String
    var followeeCount: Int?
    var followerCount: Int?
    var gender: String?
    var introduction: String?
    var nickName: String
    var pofolCount: Int?
    var profileImgUrl: String?
    var region: String?
    var session: Int?
    var userIdx: Int?
}

extension UserInfoData: Decodable {
    init(from decoder: Decoder) throws {
        let codingKeys = try decoder.container(keyedBy: CodingKeys.self)
        let infoKeys = try codingKeys.nestedContainer(keyedBy: InfoKeys.self, forKey: .result)
        
        self.birth = try infoKeys.decode(String.self, forKey: .birth)
        self.followeeCount = try infoKeys.decode(Int.self, forKey: .followeeCount)
        self.followerCount = try infoKeys.decode(Int.self, forKey: .followerCount)
        self.gender = try infoKeys.decode(String.self, forKey: .gender)
        self.introduction = try infoKeys.decode(String?.self, forKey: .introduction)
        self.nickName = try infoKeys.decode(String.self, forKey: .nickName)
        self.pofolCount = try infoKeys.decode(Int.self, forKey: .pofolCount)
        self.profileImgUrl = try infoKeys.decode(String?.self, forKey: .profileImgUrl)
        self.region = try infoKeys.decode(String.self, forKey: .region)
        self.session = try infoKeys.decode(Int.self, forKey: .session)
        self.userIdx = try infoKeys.decode(Int.self, forKey: .userIdx)
    }
}
