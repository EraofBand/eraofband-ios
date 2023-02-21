//
//  DefaultResultData.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2023/02/21.
//

import Foundation

struct DefaultResultModel: Codable {
    
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: String
    
}
