//
//  RegisterData.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/09.
//

import Foundation

struct RegisterData{
    var birth: String
    var gender: String
    var nickName: String
    var profileImgUrl: String
    var region: String
    var userSession: Int
    
    init(birth: String, gender: String, nickName: String, profileImgUrl: String, region: String, userSession: Int){
        self.birth = birth
        self.gender = gender
        self.nickName = nickName
        self.profileImgUrl = profileImgUrl
        self.region = region
        self.userSession = userSession
    }
    
    mutating func setBirth(newBirth: String){
        birth = newBirth
    }
    mutating func setGender(newGender: String){
        gender = newGender
    }
    mutating func setNickName(newNickName: String){
        nickName = newNickName
    }
    mutating func setProfileImgUrl(newProfileImgUrl: String){
        profileImgUrl = newProfileImgUrl
    }
    mutating func setRegion(newRegion: String){
        region = newRegion
    }
    mutating func setSession(newSession: Int){
        userSession = newSession
    }

}
