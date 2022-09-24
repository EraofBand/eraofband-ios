//
//  BlockTableViewCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/09/18.
//

import UIKit

class BlockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var blockButton: UIButton!
    var nickName: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = 20
        blockButton.layer.cornerRadius = 14
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
