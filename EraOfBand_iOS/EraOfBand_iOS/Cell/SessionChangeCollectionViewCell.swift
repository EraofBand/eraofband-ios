//
//  SessionChangeCollectionViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/18.
//

import UIKit

class SessionChangeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sessionImageView: UIImageView!
    @IBOutlet weak var sessionLabel: UILabel!
    
    var sessionName: String? {
        didSet {
            sessionLabel.text = sessionName
        }
    }
    
    override var isSelected: Bool {
      didSet {
        if isSelected {
            sessionImageView.image = UIImage(named: "ic_session_on")
        } else {
            sessionImageView.image = UIImage(named: "ic_session_off")
        }
      }
    }
    
    
}
