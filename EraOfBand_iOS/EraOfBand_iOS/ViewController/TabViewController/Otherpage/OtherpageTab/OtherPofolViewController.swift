//
//  OtherPofolViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/19.
//

import UIKit
import Alamofire

class OtherPofolViewController: UIViewController {
    @IBOutlet weak var pofolCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pofolCollectionView.delegate = self
        pofolCollectionView.dataSource = self
    
    }
    
}

extension OtherPofolViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 5


    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PorfolCollectionViewCell", for: indexPath) as! PorfolCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .gray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let myPofolTableVC = self.storyboard?.instantiateViewController(withIdentifier: "PofolTableViewController") as? PofolTableViewController else {return}
        myPofolTableVC.selectedIndex = indexPath
        
                
        self.navigationController?.pushViewController(myPofolTableVC, animated: true)
    }
}

extension OtherPofolViewController: UICollectionViewDelegateFlowLayout {
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    // cell 사이즈( 옆 라인을 고려하여 설정 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width / 3 - 2 ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌

        let size = CGSize(width: width, height: width)

        return size
    }
}
