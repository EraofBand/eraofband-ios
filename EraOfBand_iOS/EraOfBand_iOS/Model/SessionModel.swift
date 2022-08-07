//
//  SessionModel.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/08.
//

import UIKit

class SessionModel
{
    var name = ""
    var icon: UIImage
    
    init(name: String, icon: UIImage){
        self.name = name
        self.icon = icon
    }
    
    static func fetchMember() -> [SessionModel]
    {
        return[
            SessionModel(name: "보컬", icon: UIImage(named: "session_icon")!),
            SessionModel(name: "기타", icon: UIImage(named: "session_icon")!),
            SessionModel(name: "베이스", icon: UIImage(named: "session_icon")!),
            SessionModel(name: "드럼", icon: UIImage(named: "session_icon")!),
            SessionModel(name: "키보드", icon: UIImage(named: "session_icon")!)
        ]
    }
}
