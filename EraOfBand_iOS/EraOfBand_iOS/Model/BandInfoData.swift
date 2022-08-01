//
//  BandInfoData.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/28.
//

import Foundation

struct BandInfoData: Codable{
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: BandInfoResult?
}

struct BandInfoResult: Codable{
    
    // band introduction data
    var sessionMembers: [SessionMember]?
    var bandContent: String?
    var bandIdx: Int?
    var bandImgUrl: String?
    var bandIntroduction: String?
    var bandLikeCount: Int?
    var bandRegion: String?
    var bandTitle: String?
    var chatRoomLink: String?
    var capacity: Int?
    var likeOrNot: String?
    var memberCount: Int?
    var nickName: String?
    var performDate: String?
    var performFee: Int?
    var performLocation: String?
    var performTime: String?
    var profileImgUrl: String?
    var userIdx: Int?
    var userIntroduction: String?
    
    // session recruit data
    var applicants: [Applicant]?
    var vocal: Int
    var vocalComment: String
    var guitar: Int
    var guitarComment: String
    var base: Int
    var baseComment: String
    var keyboard: Int
    var keyboardComment: String
    var drum: Int
    var drumComment: String
    
}

struct Applicant: Codable{
    var buSession: Int?
    var introduction: String?
    var nickName: String?
    var profileImgUrl: String?
    var updatedAt: String?
    var userIdx: Int?
}

struct SessionMember: Codable{
    var buSession: Int?
    var introduction: String?
    var nickName: String?
    var profileImgUrl: String?
    var userIdx: Int?
}
