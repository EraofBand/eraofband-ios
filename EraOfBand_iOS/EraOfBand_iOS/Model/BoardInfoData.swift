//
//  BoardInfoData.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/16.
//

import Foundation

struct BoardInfoData: Codable {
    
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: boardInfoResult
    
}

struct boardInfoResult: Codable {
    
    var boardIdx: Int
    var boardLikeCount: Int
    var category: Int
    var commentCount: Int
    var content: String
    var getBoardComments: [boardCommentsInfo]
    var getBoardImgs: [boardImgInfo]
    var likeOrNot: String
    var nickName: String
    var profileImgUrl: String
    var title: String
    var updatedAt: String
    var userIdx: Int
    var views: Int

}

struct boardCommentsInfo: Codable {
    
    var boardCommentIdx: Int
    var boardIdx: Int
    var classNum: Int
    var content: String
    var groupNum: Int
    var nickName: String
    var profileImgUrl: String
    var updatedAt: String
    var userIdx: Int
    
}

struct boardImgInfo: Codable {
    
    var boardImgIdx: Int
    var imgUrl: String
    
}
