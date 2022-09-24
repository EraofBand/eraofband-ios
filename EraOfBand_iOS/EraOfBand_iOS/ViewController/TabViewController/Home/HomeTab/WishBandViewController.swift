//
//  WishBandViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/23.
//

import UIKit
import Alamofire

class WishBandViewController: UIViewController {

    @IBOutlet weak var wishBandListTableView: UITableView!
    
    var bandList: [bandInfo] = []
    var refreshControl = UIRefreshControl()
    
    func getWishBandList() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var url = appDelegate.baseUrl + "/sessions/info/likes"
        print("url: \(url)")
        
        url = url.encodeUrl()!
        let header: HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                   "Content-Type": "application/json"]
        
        let request = AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header)
        
        request.responseDecodable(of: BandListData.self) { [self] response in
            switch response.result {
            case .success(let bandListData):
                bandList = bandListData.result
                print(bandList)
            case .failure(let err):
                print(err)
            }
        }
        
        wishBandListTableView.delegate = self
        wishBandListTableView.dataSource = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getWishBandList()
        
        /*리프레쉬 세팅*/
        wishBandListTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        getWishBandList()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.wishBandListTableView.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        wishBandListTableView.reloadData()
        
    }
    

    

}

extension WishBandViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bandList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BandListTableViewCell", for: indexPath) as! BandListTableViewCell
        
        cell.backgroundColor = .clear
        
        let bandinfo = bandList[indexPath.item]
        let url = URL(string: bandinfo.bandImgUrl)!
        cell.tableImageView.load(url: url)
        cell.tableImageView.contentMode = .scaleAspectFill
        cell.tableRegionLabel.text = bandinfo.bandRegion
        cell.tableTitleLabel.text = bandinfo.bandTitle
        cell.tableIntroLabel.text = bandinfo.bandIntroduction
        
        cell.memberNumLabel.text = String(bandinfo.memberCount) + " / " + String(bandinfo.capacity)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bandRecruitVC = self.storyboard?.instantiateViewController(withIdentifier: "BandRecruitViewController") as? BandRecruitViewController else { return }
        
        GetBandInfoService.getBandInfo(bandList[indexPath.row].bandIdx){ [self]
            (isSuccess, response) in
            if isSuccess{
                bandRecruitVC.bandInfo = response.result
                bandRecruitVC.bandIdx = bandList[indexPath.row].bandIdx
                
                self.navigationController?.pushViewController(bandRecruitVC, animated: true)
            }
        }
    }
}
