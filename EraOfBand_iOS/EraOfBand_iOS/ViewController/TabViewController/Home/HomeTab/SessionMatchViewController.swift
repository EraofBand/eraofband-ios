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
    @IBOutlet weak var firstBandTitleLabel: UILabel!
    @IBOutlet weak var firstBandIntro: UILabel!
    @IBOutlet weak var secondBandTitleLabel: UILabel!
    @IBOutlet weak var secondBandIntro: UILabel!
    @IBOutlet weak var thirdBandTitleLabel: UILabel!
    @IBOutlet weak var thirdBandIntro: UILabel!
    
    var newBandList: [newBandInfo] = []
    var fameBandList: [fameBandInfo] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func bandListAction(_ sender: Any) {
        
        guard let bandListVC = storyboard?.instantiateViewController(withIdentifier: "BandListViewController") as? BandListViewController else { return }
        
        navigationController?.pushViewController(bandListVC, animated: true)
        
        
    }
    
    func getNewBand(completion: @escaping() -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var url = appDelegate.baseUrl + "/sessions/home/new"
        url = url.encodeUrl()!
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let request = AF.request(url,
                                 method: .get,
                                 encoding: JSONEncoding.default,
                                 headers: header)
        
        request.responseDecodable(of: NewBandData.self) { [self] response in
            switch response.result{
            case .success(let data):
                newBandList = data.result
                print(newBandList)
                completion()
                
            case .failure(let err):
                print(err)
            }
            
        }
        
    }
    
    func getfameBand(completion: @escaping () -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var url = appDelegate.baseUrl + "/sessions/home/fame"
        url = url.encodeUrl()!
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let request = AF.request(url,
                                 method: .get,
                                 encoding: JSONEncoding.default,
                                 headers: header)
        
        request.responseDecodable(of: FameBandData.self) { [self] response in
            switch response.result{
            case .success(let data):
                fameBandList = data.result
                print(fameBandList)
                completion()
                
            case .failure(let err):
                print(err)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNewBand() { [self] in
            newBandCollectionView.delegate = self
            newBandCollectionView.dataSource = self
            newBandCollectionView.register(UINib(nibName: "HomeBandCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeBandCollectionViewCell")
        }
        
        getfameBand() { [self] in
            
            firstBandImageView.load(url: URL(string: fameBandList[0].bandImgUrl)!)
            firstBandImageView.contentMode = .scaleAspectFill
            firstBandTitleLabel.text = fameBandList[0].bandTitle
            firstBandIntro.text = fameBandList[0].bandIntroduction
            
            secondBandImageView.load(url: URL(string: fameBandList[1].bandImgUrl)!)
            secondBandImageView.contentMode = .scaleAspectFill
            secondBandTitleLabel.text = fameBandList[1].bandTitle
            secondBandIntro.text = fameBandList[1].bandIntroduction
            
            thirdBandImageView.load(url: URL(string: fameBandList[2].bandImgUrl)!)
            thirdBandImageView.contentMode = .scaleAspectFill
            thirdBandTitleLabel.text = fameBandList[2].bandTitle
            thirdBandIntro.text = fameBandList[2].bandIntroduction
            
            firstBandImageView.layer.cornerRadius = 16
            secondBandImageView.layer.cornerRadius = 16
            thirdBandImageView.layer.cornerRadius = 16
        }
        
    }

}

extension SessionMatchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("newBandList: \(newBandList)")
        
        return newBandList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBandCollectionViewCell", for: indexPath) as! HomeBandCollectionViewCell
        
        cell.backgroundColor = .clear
        
        let newBand: newBandInfo = newBandList[indexPath.item]
        let url = URL(string: newBand.bandImgUrl)
        
        cell.bandImageView.load(url: url!)
        cell.bandImageView.contentMode = .scaleAspectFill
        cell.bandTitleLabel.text = newBand.bandTitle
        cell.bandDistrictLabel.text = newBand.bandRegion
        
        let sessionNum = String(newBand.sessionNum)
        let totalNum = String(newBand.totalNum)
        
        cell.bandCountLabel.text = "\(sessionNum)/\(totalNum)"
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let bandRecruitVC = self.storyboard?.instantiateViewController(withIdentifier: "BandRecruitViewController") as? BandRecruitViewController else { return }
        
        GetBandInfoService.getBandInfo(newBandList[indexPath.row].bandIdx){ [self]
            (isSuccess, response) in
            if isSuccess{
                bandRecruitVC.bandInfo = response.result
                bandRecruitVC.bandIdx = newBandList[indexPath.row].bandIdx
                self.navigationController?.pushViewController(bandRecruitVC, animated: true)
            }
        }
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
