//
//  RecruitHeaderView.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/08.
//

import UIKit

class RecruitHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var recruitLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func moreButtonTapped(sender: UIButton) {
        
        print("더보기 버튼 클릭")
        
    }
    
    
}
