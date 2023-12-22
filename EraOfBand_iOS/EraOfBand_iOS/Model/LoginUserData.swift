//
//  LoginUserData.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/15.
//

import Foundation

struct LoginUserData: Codable{
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: LoginResult
}

struct LoginResult: Codable{
    var expiration: Int?
    var jwt: String?
    var refresh: String?
    var userIdx: Int?
}
