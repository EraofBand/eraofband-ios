//
//  HomeBandCollectionViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/23.
//

import UIKit

class HomeBandCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bandImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bandImageView.backgroundColor = .gray
        bandImageView.layer.cornerRadius = 10
    }

}
