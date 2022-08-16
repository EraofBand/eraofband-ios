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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var thumbNailView: UIView!
    @IBOutlet weak var thumbNailImg: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var menuBtn: PofolMenuButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
