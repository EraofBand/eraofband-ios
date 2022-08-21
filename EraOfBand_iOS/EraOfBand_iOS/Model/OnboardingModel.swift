//
//  OnboardingModel.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/03.
//

import UIKit

class OnboardingModel
{
    var title = ""
    var description = ""
    var onboardingImg: UIImage
    
    init(title: String, description: String, onboardingImg: UIImage){
        self.title = title
        self.description = description
        self.onboardingImg = onboardingImg
    }
    
    static func fetchMember() -> [OnboardingModel]
    {
        return[
            OnboardingModel(title: "밴드 결성을 쉽고 간편하게", description: "모집 중인 밴드에 가입하거나\n직접 밴드를 결성해 세션들을 모집할 수 있어요", onboardingImg: UIImage(named: "onboarding1")!),
            OnboardingModel(title: "레슨 정보도 빠르게!", description: "복잡하고 알기 어려웠던 주변의 악기, 보컬 레슨에\n대한 정보를 한눈에 확인할 수 있어요", onboardingImg: UIImage(named: "onboarding2")!),
            OnboardingModel(title: "나만의 음악 포트폴리오 만들기", description: "열심히 연습한 곡들을 나만의 음악\n포트폴리오에 추가해 모두에게 내 실력을 뽐낼 수 있어요", onboardingImg: UIImage(named: "onboarding3")!),
            OnboardingModel(title: "이제 음악은 함께 즐겨야지!", description: "다양한 사람들과 포트폴리오를 공유하고 게시판, 채팅을\n통해 자유롭게 소통 할 수 있어요", onboardingImg: UIImage(named: "onboarding4")!)
        ]
    }
}
