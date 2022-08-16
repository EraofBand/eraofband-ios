//
//  BoardListModel.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/16.
//

import Foundation

struct BoardListModel: Codable{
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: [BoardListResult]
}

struct BoardListResult: Codable{
    var boardIdx: Int
    var boardLikeCount: Int
    var category: Int
    var commentCount: Int
    var content: String
    //var imgUrl: String
    var nickName: String
    var title: String
    var updatedAt: String
    var userIdx: Int
    var views: Int
}
