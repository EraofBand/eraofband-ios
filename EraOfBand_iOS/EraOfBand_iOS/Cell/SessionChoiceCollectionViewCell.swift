//
//  SessionChoiceCollectionViewCell.swift
//  EraOfBand_iOS
//
//  Created by κΉμν on 2022/07/28.
//

import UIKit

class SessionChoiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sessionLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected{
                backgroundColor = #colorLiteral(red: 0.1057075635, green: 0.4936558008, blue: 0.9950549006, alpha: 1)
            } else {
                backgroundColor = .clear
            }
        }
    }
    
}
