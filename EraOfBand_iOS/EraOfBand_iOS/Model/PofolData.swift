//
//  PofolData.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/14.
//

import Foundation

struct PofolData: Codable
{
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: [PofolResult]
}

struct PofolResult: Codable{
    var commentCount: Int?
    var content: String?
    var imgUrl: String
    var likeOrNot: String?
    var nickName: String?
    var pofolIdx: Int?
    var pofolLikeCount: Int?
    var profileImgUrl: String?
    var title: String?
    var updatedAt: String?
    var userIdx: Int?
    var videoUrl: String?
}
