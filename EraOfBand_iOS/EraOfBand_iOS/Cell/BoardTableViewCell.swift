//
//  BoardTableViewCell.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/16.
//

import UIKit

class BoardTableViewCell: UITableViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var commentNum: UILabel!
    @IBOutlet weak var boardName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
