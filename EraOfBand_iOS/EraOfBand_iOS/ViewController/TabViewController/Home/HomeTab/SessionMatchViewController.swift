//
//  SessionViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/23.
//

import UIKit
import Alamofire

class SessionMatchViewController: UIViewController {

    @IBOutlet weak var newBandCollectionView: UICollectionView!
    @IBOutlet weak var firstBandImageView: UIImageView!
    @IBOutlet weak var secondBandImageView: UIImageView!
    @IBOutlet weak var thirdBandImageView: UIImageView!
    
    @IBAction func bandListAction(_ sender: Any) {
        
        guard let bandListVC = storyboard?.instantiateViewController(withIdentifier: "BandListViewController") as? BandListViewController else { return }
        
        navigationController?.pushViewController(bandListVC, animated: true)
        
        
    }
    
    func getNewBand() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let url = appDelegate.baseUrl + "​/sessions​/home​/new"
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let request = AF.request(url,
                                 method: .get,
                                 encoding: JSONEncoding.default,
                                 headers: header)
        
        request.responseJSON { response in
            print(response)
        }
        
        request.responseDecodable(of: NewBandData.self) { response in
            switch response.result{
            case .success(let data):
                let bandList = data.result
                print(bandList)
            case .failure(let err):
                print(err)
            }
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNewBand()
        
        newBandCollectionView.delegate = self
        newBandCollectionView.dataSource = self
        newBandCollectionView.register(UINib(nibName: "HomeBandCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeBandCollectionViewCell")
        
        firstBandImageView.layer.cornerRadius = 24
        secondBandImageView.layer.cornerRadius = 24
        thirdBandImageView.layer.cornerRadius = 24
        
    }

}

extension SessionMatchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBandCollectionViewCell", for: indexPath) as! HomeBandCollectionViewCell
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
}

extension SessionMatchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150, height: collectionView.frame.height) // point
    }

    // 맨 앞 셀 마진
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    
    }
    
}
