//
//  BoardImageCollectionViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/16.
//

import UIKit

class BoardImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BoardImageCollectionViewCell"
    
    @IBOutlet weak var boardImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        boardImageView.layer.cornerRadius = 10
        boardImageView.contentMode = .scaleAspectFill
    }

}
