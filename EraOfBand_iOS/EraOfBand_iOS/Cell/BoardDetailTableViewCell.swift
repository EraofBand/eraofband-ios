//
//  DetailNoticeHeaderViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/16.
//

import UIKit

class BoardDetailTableViewCell: UITableViewCell {
    
    static let identifier = "BoardTableViewCell"

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userTimeLabel: UILabel!
    @IBOutlet weak var noticeImgView: UIView!
    @IBOutlet weak var noticeImgCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var ectLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    let boardImageDataSource = BoardImageDataSource()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 25
        
        registerXib()
        registerDelegate()
        
    }
    
    private func registerXib() {
        let storyNib = UINib(nibName: BoardImageCollectionViewCell.identifier, bundle: nil)
        noticeImgCollectionView.register(storyNib, forCellWithReuseIdentifier: BoardImageCollectionViewCell.identifier)
    }
    
    private func registerDelegate() {
        noticeImgCollectionView.delegate = self
        noticeImgCollectionView.dataSource = self
    }
    
}

extension BoardDetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
