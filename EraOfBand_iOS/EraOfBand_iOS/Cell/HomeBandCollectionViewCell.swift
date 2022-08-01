//
//  HomeBandCollectionViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/23.
//

import UIKit

class HomeBandCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bandImageView: UIImageView!
    
    @IBOutlet weak var bandDistrictLabel: UILabel!
    @IBOutlet weak var bandTitleLabel: UILabel!
    @IBOutlet weak var bandCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bandImageView.backgroundColor = .gray
        bandImageView.layer.cornerRadius = 10
    }

    override func prepareForReuse() {
        bandImageView.image = nil
    }
}
