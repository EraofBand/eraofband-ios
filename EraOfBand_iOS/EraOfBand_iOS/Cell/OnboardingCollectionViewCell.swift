//
//  OnboardingCollectionViewCell.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/03.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var onboardingImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var onboardingModel: OnboardingModel!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        if let onboardingModel = onboardingModel{
            onboardingImg.image = onboardingModel.onboardingImg
            
            let text = onboardingModel.title
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text as NSString).range(of: "밴드 결성"))
            attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text as NSString).range(of: "레슨 정보"))
            attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text as NSString).range(of: "나만의 음악 포트폴리오"))
            attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text as NSString).range(of: "함께 즐겨야지!"))
            
            titleLabel.attributedText = attributedString
            descriptionLabel.text = onboardingModel.description
        } else{
            onboardingImg.image = nil
            titleLabel.text = nil
            descriptionLabel.text = nil
        }
    }
}
