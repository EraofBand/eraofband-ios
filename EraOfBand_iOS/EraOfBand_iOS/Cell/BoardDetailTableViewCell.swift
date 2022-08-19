//
//  DetailNoticeHeaderViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/16.
//

import UIKit

class BoardDetailTableViewCell: UITableViewCell {
    
    static let identifier = "BoardDetailTableViewCell"

    @IBOutlet weak var boardStackView: UIStackView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userTimeLabel: UILabel!
    @IBOutlet weak var noticeImgView: UIView!
    @IBOutlet weak var noticeImgCollectionView: UICollectionView!
    @IBOutlet weak var imgPageControl: UIPageControl!
    @IBOutlet weak var boardContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var ectLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    let boardImageDataSource = BoardImageDataSource()
    
    var currentPage: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 25
        
    }
    
    func registerXib() {
        let boardImageNib = UINib(nibName: BoardImageCollectionViewCell.identifier, bundle: nil)
        noticeImgCollectionView.register(boardImageNib, forCellWithReuseIdentifier: BoardImageCollectionViewCell.identifier)
    }
    
    func registerDelegate() {
        noticeImgCollectionView.delegate = self
        noticeImgCollectionView.dataSource = boardImageDataSource
    }
    
}

extension BoardDetailTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        self.imgPageControl.currentPage = Int(scrollView.contentOffset.x / width)
    }

}
