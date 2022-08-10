//
//  MessageListTableViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/09.
//

import UIKit

class MessageListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var RecentMessageLabel: UILabel!
    @IBOutlet weak var updateAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = 22
        userImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
