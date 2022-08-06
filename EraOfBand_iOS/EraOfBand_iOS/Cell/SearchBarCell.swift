//
//  SearchBarCell.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/06.
//

import Foundation
import UIKit

class SearchBarCell: UICollectionViewCell {
    static let identifier = "SearchBarCell"
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 클릭했을 때, 색상이 바뀔 수 있게 설정
    override var isSelected: Bool {
        didSet {
            textLabel.font = isSelected ? UIFont(name: "Pretendard-Bold", size: 14) : UIFont(name: "Pretendard-Medium", size: 14)
            textLabel.textColor = isSelected ? #colorLiteral(red: 0.1057075635, green: 0.4936558008, blue: 0.9950549006, alpha: 1) : .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(textLabel)
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
