//
//  BandListTableViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/26.
//

import UIKit

class BandListTableViewCell: UITableViewCell {

    @IBOutlet weak var bandImageView: UIImageView!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var bandNameLabel: UILabel!
    @IBOutlet weak var bandIntroLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bandImageView.layer.cornerRadius = 10
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.backgroundColor = #colorLiteral(red: 0.1672143638, green: 0.1786631942, blue: 0.208065331, alpha: 1)
        contentView.layer.cornerRadius = 15
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
}
