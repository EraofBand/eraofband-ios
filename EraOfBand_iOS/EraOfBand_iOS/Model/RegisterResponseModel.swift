//
//  RegisterResponseModel.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/11.
//

import Foundation

struct RegisterResponseModel : Codable{
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : Result?
}

struct Result : Codable{
    var jwt : String?
    var userIdx : Int?
}
