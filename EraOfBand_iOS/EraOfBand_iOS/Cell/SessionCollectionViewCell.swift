//
//  SessionCollectionViewCell.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/08.
//

import UIKit

class SessionCollectionViewCell: UICollectionViewCell
{
   
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var sessionIcon: UIImageView!
    @IBOutlet weak var sessionName: UILabel!
    
    var isChecked: Bool = false
    
    var sessionModel: SessionModel!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        if let sessionModel = sessionModel{
            sessionIcon.image = sessionModel.icon
            
            sessionName.text = sessionModel.name

        } else{
            sessionIcon.image = nil
            sessionName.text = nil
        }
    }
}
