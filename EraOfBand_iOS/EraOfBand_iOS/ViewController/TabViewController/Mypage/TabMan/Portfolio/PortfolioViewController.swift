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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
