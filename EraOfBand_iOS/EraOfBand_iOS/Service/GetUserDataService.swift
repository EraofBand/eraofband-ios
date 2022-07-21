//
//  GetUserDataService.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/16.
//

import Foundation
import Alamofire
import UIKit

struct GetUserDataService {
    
    // 여러 vc에서도 shared로 접근하면 같은 인스턴스에 접근할 수 있음
    static let shared = GetUserDataService()
    
    // completion 클로저를 @escaping closure로 정의
    // -> getPersonInfo 함수가 종료되든 말든 상관없이 completion은 탈출 클로저이기 때문에, 전달된다면 이후에 외부에서도 사용가능
    // ** 해당 completion 클로저에는 네트워크의 결과를 담아서 호출하게 되고, VC에서 꺼내서 처리할 예정
    func getUserInfo(completion : @escaping (NetworkResult<Any>) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let URL = appDelegate.baseUrl + "/users/info/my-page/" + String(appDelegate.userIdx!)
        print(URL)
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        
        let dataRequest = AF.request(URL,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            
            switch dataResponse.result {
            case .success:
                // dataResponse.statusCode는 Response의 statusCode - 200/400/500
                guard let statusCode = dataResponse.response?.statusCode else {return}
                // dataResponse.value는 Response의 결과 데이터
                guard let value = dataResponse.value else { return }
                
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                
                // 통신 실패의 경우, completion에 pathErr값을 담아서 뷰컨으로 날려줍니다.
                // 타임아웃 / 통신 불가능의 상태로 통신 자체에 실패한 경우입니다.
            case .failure:
                print("error")
                completion(.pathErr)
            }
            
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        switch statusCode {
        case 200: return isValidData(data: data) // 성공 -> 데이터를 가공해서 전달해줘야 하기 때문에 isValidData라는 함수로 데이터 넘격줌
        case 400: return .pathErr // -> 요청이 잘못됨
        case 500: return .serverErr // -> 서버 에러
        default: return .networkFail // -> 네트워크 에러로 분기 처리할 예정
            
        }
    }
    
    private func isValidData(data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(UserDataModel.self, from: data) else { return .pathErr }
        
        return .success(decodedData.result)
    }
    
}
