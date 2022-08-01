//
//  ApplicantsTableViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/01.
//

import UIKit

class ApplicantsTableViewCell: UITableViewCell {

    @IBOutlet weak var applicantImageView: UIImageView!
    @IBOutlet weak var applicantSession: UILabel!
    @IBOutlet weak var applicantNickName: UILabel!
    @IBOutlet weak var applicantIntro: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var recruitDicision: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        applicantImageView.layer.cornerRadius = 22
        
        applicantSession.layer.cornerRadius = 10
        applicantSession.layer.borderWidth = 1
        applicantSession.layer.borderColor = #colorLiteral(red: 0.1057075635, green: 0.4936558008, blue: 0.9950549006, alpha: 1)
        
        recruitDicision.layer.cornerRadius = 15
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.backgroundColor = .clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
        
    }

}
