//
//  BoardImageDataSource.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/16.
//

import Foundation
import UIKit

class BoardImageDataSource: NSObject, UICollectionViewDataSource {
    
    var boardImage: [boardImgInfo] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardImageCollectionViewCell.identifier, for: indexPath) as! BoardImageCollectionViewCell
        
        if let url = URL(string: boardImage[indexPath.item].imgUrl) {
            cell.boardImageView.load(url: url)
        }
        
        return cell
    }
    
}
