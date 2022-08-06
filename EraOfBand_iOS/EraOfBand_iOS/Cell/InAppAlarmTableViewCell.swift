//
//  InAppAlarmTableViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/04.
//

import UIKit

class InAppAlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var alarmImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var activeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        alarmImageView.contentMode = .scaleAspectFill
        alarmImageView.layer.cornerRadius = 25
        activeView.layer.cornerRadius = 2.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
