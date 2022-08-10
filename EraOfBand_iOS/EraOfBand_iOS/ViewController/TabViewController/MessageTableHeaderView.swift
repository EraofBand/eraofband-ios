//
//  MessageTableHeaderView.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/09.
//

import UIKit

class MessageTableHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchView.layer.cornerRadius = 10
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
