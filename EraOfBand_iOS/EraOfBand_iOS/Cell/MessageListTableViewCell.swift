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
    @IBOutlet weak var checkView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = 22
        userImageView.contentMode = .scaleAspectFill
        checkView.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func calcDate(_ updateAt: Int64) {
        let nowAt = Date().Date_To_MilliSeconds
        
        let time = nowAt - updateAt
        
        let seconds: Int = Int(time / 1000)
        let minutes: Int = Int(time / (1000*60))
        let hours: Int = Int(time / (1000*60*60))
        let days: Int = Int(time / (1000*60*60*24))
        
        if days == 0 {
            if hours == 0 {
                if minutes == 0{
                    updateAtLabel.text = "방금 전"
                } else {
                    updateAtLabel.text = "\(minutes)분 전"
                }
            } else {
                updateAtLabel.text = "\(hours)시간 전"
            }
        } else {
            updateAtLabel.text = "\(days)일 전"
        }
        
    }

}

extension Date {
    
    // [Date >> milliseconds 변환 수행]
    var Date_To_MilliSeconds: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded()) // [rounded 반올림 처리]
    }
    
    // [milliseconds >> Date 변환 수행]
    init(MilliSeconds_To_Date: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(MilliSeconds_To_Date) / 1000)
    }
}
