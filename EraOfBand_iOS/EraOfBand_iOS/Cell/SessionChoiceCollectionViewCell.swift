//
//  SessionChoiceCollectionViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/28.
//

import UIKit

class SessionChoiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sessionLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected{
                backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.3921568627, blue: 0.9921568627, alpha: 1)
            } else {
                backgroundColor = .clear
            }
        }
    }
    
}
