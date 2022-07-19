//
//  FollowTableViewCell.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/19.
//

import UIKit

class FollowTableViewCell: UITableViewCell{
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
