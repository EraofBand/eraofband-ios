//
//  MyPofolTableViewCell.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/15.
//

import UIKit

class MyPofolTableViewCell: UITableViewCell{
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pofolImgView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
