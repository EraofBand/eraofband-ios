//
//  PortfolioViewController.swift
//  EraOfBand_iOS
//
//  Created by κΉμν on 2022/07/11.
//

import UIKit
import Alamofire
import Kingfisher

class PortfolioViewController: UIViewController{
    
    var pofolList: [GetUserPofol] = [GetUserPofol(imgUrl: "", pofolIdx: 0)]
    var thumbNailList: [String] = [""]
    
    @IBOutlet weak var porfolCollectionView: UICollectionView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getPofolList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/info/my-page/" + String(appDelegate.userIdx!),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: UserDataModel.self){ response in
            
            let responseData = response.value
            self.pofolList = (responseData?.result.getUserPofol)!
            
            self.porfolCollectionView.reloadData()
        }
        
    }
    
    var pofolCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        porfolCollectionView.delegate = self
        porfolCollectionView.dataSource = self
        
        self.view.backgroundColor = #colorLiteral(red: 0.1672143638, green: 0.1786631942, blue: 0.208065331, alpha: 1)
        
        getPofolList()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPofolList()
    }

}

extension PortfolioViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        
        //print(pofolList)
        
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
        myPofolTableVC.userIdx = appDelegate.userIdx ?? 0
        myPofolTableVC.thumbNailList = self.thumbNailList
                
        self.navigationController?.pushViewController(myPofolTableVC, animated: true)
    }
}

extension PortfolioViewController: UICollectionViewDelegateFlowLayout {
    // μ μλ κ°κ²©
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }

    // μ κ°κ²©
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    // cell μ¬μ΄μ¦( μ λΌμΈμ κ³ λ €νμ¬ μ€μ  )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width / 3 - 2 ///  3λ±λΆνμ¬ λ°°μΉ, μ κ°κ²©μ΄ 1μ΄λ―λ‘ 1μ λΉΌμ€

        let size = CGSize(width: width, height: width)
        
        return size
    }
}
