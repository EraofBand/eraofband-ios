//
//  CommentTableViewCell.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/16.
//

import UIKit

class CommentTableViewCell: UITableViewCell{
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileBtn: UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
