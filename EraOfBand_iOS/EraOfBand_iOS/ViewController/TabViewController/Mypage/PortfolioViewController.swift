//
//  PortfolioViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/11.
//

import UIKit

class PortfolioViewController: UIViewController {
    
    @IBOutlet weak var porfolCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        porfolCollectionView.delegate = self
        porfolCollectionView.dataSource = self
        
    }
    

}

extension PortfolioViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 3

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PorfolCollectionViewCell", for: indexPath) as! PorfolCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .gray
        
        //cell.porfolButton.addTarget(self, action: #selector(cellTapped(sender: self, indexPath: indexPath)), for: .touchUpInside)
        
        return cell
    }
    
    /*
    @objc func cellTapped(sender: UIButton, indexPath: IndexPath){
        print("test")
    }*/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let myPofolTableVC = self.storyboard?.instantiateViewController(withIdentifier: "PofolTableViewController") as? PofolTableViewController else {return}
        myPofolTableVC.selectedIndex = indexPath
                
        self.navigationController?.pushViewController(myPofolTableVC, animated: true)
    }
}

extension PortfolioViewController: UICollectionViewDelegateFlowLayout {
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

        let width = collectionView.frame.width / 3 - 1 ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌

        let size = CGSize(width: width, height: width)

        return size
    }
}
