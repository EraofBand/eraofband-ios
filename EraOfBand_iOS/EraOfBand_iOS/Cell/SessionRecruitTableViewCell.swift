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
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var recruitButton: UIButton!
    
    var cellDelegate: CellButtonDelegate?
    
    @objc func recruitClicked() {
        cellDelegate?.recruitButtonTapped()
    }
    @objc func shareClicked() {
        cellDelegate?.shareButtonTapped()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recruitLabel.layer.cornerRadius = 10
        recruitLabel.layer.backgroundColor = #colorLiteral(red: 0.1057075635, green: 0.4936558008, blue: 0.9950549006, alpha: 1)
        recruitLabel.textColor = .white
        recruitLabel.font = UIFont(name: "Pretendard-Medium", size: 12)
        
        sessionLabel.layer.cornerRadius = 10
        sessionLabel.layer.borderWidth = 1
        sessionLabel.layer.borderColor = #colorLiteral(red: 0.1057075635, green: 0.4936558008, blue: 0.9950549006, alpha: 1)
        sessionLabel.textColor = #colorLiteral(red: 0.1057075635, green: 0.4936558008, blue: 0.9950549006, alpha: 1)
        sessionLabel.font = UIFont(name: "Pretendard-Medium", size: 12)
        
        self.recruitButton.addTarget(self, action: #selector(recruitClicked), for: .touchUpInside)
        self.shareButton.addTarget(self, action: #selector(shareClicked), for: .touchUpInside)
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.1333333333, blue: 0.1568627451, alpha: 1)
        contentView.layer.cornerRadius = 15
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        
    }

}

protocol CellButtonDelegate: AnyObject {
    
    func recruitButtonTapped()
    func shareButtonTapped()
    
}
