//
//  File.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/16.
//

import Foundation

struct CommentData: Codable
{
    var code: Int
    var isSuccess: Bool
    var message: String
}

struct CommentResult: Codable{
    var content: String
    var nickName: String
    var pofolCommentIdx: Int
    var pofolIdx: Int
    var profileImgUrl: String
    var updatedAt: String
    var userIdx: Int
}
