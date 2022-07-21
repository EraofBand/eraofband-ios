//
//  OtherPofolViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/19.
//

import UIKit
import Alamofire

class OtherPofolViewController: UIViewController {
    
    var pofolList: [PofolResult] = [PofolResult(commentCount: 0, content: "", likeOrNot: "", nickName: "", pofolIdx: 0, pofolLikeCount: 0, profileImgUrl: "", title: "", updatedAt: "", userIdx: 0, videoUrl: "")]
    
    
    @IBOutlet weak var pofolCollectionView: UICollectionView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getPofolList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/pofols/info/" + String(appDelegate.otherUserIdx!),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success(let obj):
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj,
                                           options: .prettyPrinted)
                    let getData = try JSONDecoder().decode(PofolData.self, from: dataJSON)
                    //print(response)
                    self.pofolList = getData.result
                    print(self.pofolList)
                    self.pofolCollectionView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            default:
                return
            }
        }
    }
    
    var pofolCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(userIdx)
        
        pofolCollectionView.delegate = self
        pofolCollectionView.dataSource = self
        getPofolList()
    
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let myPofolTableVC = self.storyboard?.instantiateViewController(withIdentifier: "PofolTableViewController") as? PofolTableViewController else {return}
        myPofolTableVC.selectedIndex = indexPath
        myPofolTableVC.userIdx = appDelegate.otherUserIdx ?? 0
                
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
