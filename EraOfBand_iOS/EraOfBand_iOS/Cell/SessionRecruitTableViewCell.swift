//
//  SessionRecruitTableViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/29.
//

import UIKit

class SessionRecruitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recruitLabel: UILabel!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var recruitNumLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.1333333333, blue: 0.1568627451, alpha: 1)
        contentView.layer.cornerRadius = 15
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        
    }

}
