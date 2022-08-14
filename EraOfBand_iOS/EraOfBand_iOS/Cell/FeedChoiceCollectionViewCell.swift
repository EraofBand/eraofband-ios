//
//  FeedChoiceCollectionViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/14.
//

import UIKit

class FeedChoiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var choiceLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected{
                backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.3921568627, blue: 0.9921568627, alpha: 1)
            } else {
                backgroundColor = #colorLiteral(red: 0.1672143638, green: 0.1786631942, blue: 0.208065331, alpha: 1)
            }
        }
    }
    
}
