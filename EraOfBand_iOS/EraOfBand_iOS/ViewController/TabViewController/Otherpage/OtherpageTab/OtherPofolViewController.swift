//
//  OtherPofolViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/19.
//

import UIKit
import Alamofire
import Kingfisher

class OtherPofolViewController: UIViewController {
    var userData: OtherUser?
    var userIdx: Int?
    var pofolList: [GetUserPofol] = [GetUserPofol(imgUrl: "", pofolIdx: 0)]
    var thumbNailList: [String] = [""]
    
    
    @IBOutlet weak var pofolCollectionView: UICollectionView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /*
    func getPofolList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/info/" + String(appDelegate.otherUserIdx!),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: OtherUserDataModel.self){ response in
            
            let responseData = response.value
            print(responseData!)
            self.pofolList = (responseData?.result.getUserPofol)!
            
            self.pofolCollectionView.reloadData()
        }
    }*/
    
    var pofolCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pofolList = (userData?.getUserPofol)!
        
        pofolCollectionView.delegate = self
        pofolCollectionView.dataSource = self
        pofolCollectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
        
        //getPofolList()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //getPofolList()
    }

    
}

extension OtherPofolViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return pofolList.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PorfolCollectionViewCell", for: indexPath) as! PorfolCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .gray
        
        if( (pofolList[indexPath.row].imgUrl != "") && (pofolList[indexPath.row].imgUrl.prefix(20) == "https://eraofband.s3") ){
            cell.pofolImage.kf.setImage(with: URL(string: pofolList[indexPath.row].imgUrl))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(pofolList.count == 1){
            self.thumbNailList[0] = pofolList[0].imgUrl
        }
        
        if(pofolList.count > 1){
            self.thumbNailList[0] = pofolList[0].imgUrl
            for i in 1...pofolList.count - 1{
                self.thumbNailList.append(pofolList[i].imgUrl)
            }
        }
        
        guard let myPofolTableVC = self.storyboard?.instantiateViewController(withIdentifier: "PofolTableViewController") as? PofolTableViewController else {return}
        myPofolTableVC.selectedIndex = indexPath
        myPofolTableVC.userIdx = self.userIdx ?? 0
        myPofolTableVC.thumbNailList = self.thumbNailList
                
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

        let width = (collectionView.frame.width - 10) / 3 - 2 ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌

        let size = CGSize(width: width, height: width)

        return size
    }
}
