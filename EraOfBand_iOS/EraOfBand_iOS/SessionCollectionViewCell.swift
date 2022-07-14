//
//  SessionCollectionViewCell.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/11.
//

import UIKit

class SessionCollectionViewCell: UICollectionViewCell
{

    @IBOutlet weak var iconBorderView: UIView!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var sessionModel: SessionModel!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        if let sessionModel = sessionModel{
            iconImg.image = sessionModel.icon
            nameLabel.text = sessionModel.name
            
            checkBtn.layer.cornerRadius = 12.5
            checkBtn.layer.backgroundColor = UIColor.black.cgColor
            iconBorderView.layer.cornerRadius = 95/2
            iconBorderView.layer.borderWidth = 1.5
            iconBorderView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)

        } else{
            iconImg.image = nil
            nameLabel.text = nil
        }
    }
}
