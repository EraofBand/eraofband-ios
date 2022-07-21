//
//  FollowData.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/19.
//

import Foundation

struct FollowData: Codable{
    var code: Int?
    var isSuccess: Bool?
    var result: FollowResult?
}

struct FollowResult: Codable{
    var getfollower: [FollowUserList]?
    var getfollowing: [FollowUserList]?
}

struct FollowUserList: Codable{
    var nickName: String?
    var profileImgUrl: String?
    var userIdx: Int?
}
