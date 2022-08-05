//
//  BandLessonSearchTableViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/05.
//

import UIKit

class BandLessonSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var repreImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        repreImageView.layer.cornerRadius = 10
        repreImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
