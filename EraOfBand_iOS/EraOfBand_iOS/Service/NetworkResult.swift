//
//  NetworkResult.swift
//  EraOfBand_iOS
//
//  Created by κΉμν on 2022/07/16.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
