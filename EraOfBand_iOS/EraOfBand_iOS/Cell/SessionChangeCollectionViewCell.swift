//
//  SessionChangeCollectionViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/18.
//

import UIKit

class SessionChangeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var choiceImageView: UIImageView!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var sessionImageView: UIImageView!
    
    var sessionName: String? {
        didSet {
            sessionLabel.text = sessionName
        }
    }
    
    override var isSelected: Bool {
      didSet {
        if isSelected {
            choiceImageView.image = UIImage(named: "ic_session_on")
        } else {
            choiceImageView.image = UIImage(named: "ic_session_off")
        }
      }
    }
    
    
}
