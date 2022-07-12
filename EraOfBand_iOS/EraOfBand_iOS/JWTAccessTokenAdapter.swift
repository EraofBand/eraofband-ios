//
//  JWTAccessTokenAdapter.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/13.
//

import Foundation
import Alamofire
/*
final class JWTAccessTokenAdapter: RequestAdapter{
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        <#code#>
    }
    /*
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest

        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix("https://api.authenticated.com") {
            /// Set the Authorization header value using the access token.
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }
    */
    typealias JWT = String
    private let accessToken: JWT
    
    init(accessToken: JWT){
        self.accessToken = accessToken
    }
    
    /*
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            var urlRequest = urlRequest

            if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix("https://api.authenticated.com") {
                /// Set the Authorization header value using the access token.
                urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            }

            return urlRequest
        }
*/
}
*/
