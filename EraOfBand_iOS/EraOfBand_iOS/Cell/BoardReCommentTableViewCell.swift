//
//  BoardReCommentTableViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/21.
//

import UIKit

class BoardReCommentTableViewCell: UITableViewCell {
    
    static let identifier = "BoardReCommentTableViewCell"

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var updateAtLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
