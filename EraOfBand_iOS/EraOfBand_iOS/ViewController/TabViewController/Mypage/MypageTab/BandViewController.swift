//
//  BandViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/11.
//

import UIKit
import Alamofire

class BandViewController: UIViewController {

    var bandList: [GetUserBand]?
    @IBOutlet weak var bandTableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getBandList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/info/my-page/" + String(appDelegate.userIdx!),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: UserDataModel.self){ response in
            
            let responseData = response.value
            self.bandList = (responseData?.result.getUserBand)!
            
            self.bandTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bandTableView.delegate = self
        bandTableView.dataSource = self
        
        getBandList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBandList()
    }

}

extension BandViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bandList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BandListTableViewCell", for: indexPath) as! BandListTableViewCell
        
        let bandinfo = bandList![indexPath.row]
        
        let url = URL(string: bandinfo.bandImgUrl)!
        cell.tableImageView.load(url: url)
        cell.tableImageView.contentMode = .scaleAspectFill
        cell.tableTitleLabel.text = bandinfo.bandTitle
        cell.tableRegionLabel.text = bandinfo.bandRegion
        cell.memberNumLabel.text = String(bandinfo.memberCount) + " / " + String(bandinfo.capacity)
        cell.tableIntroLabel.text = bandinfo.bandIntroduction
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bandRecruitVC = self.storyboard?.instantiateViewController(withIdentifier: "BandRecruitViewController") as? BandRecruitViewController else { return }
        
        GetBandInfoService.getBandInfo((bandList?[indexPath.row].bandIdx)!){ [self]
            (isSuccess, response) in
            if isSuccess{
                bandRecruitVC.bandInfo = response.result
                bandRecruitVC.bandIdx = (bandList?[indexPath.row].bandIdx)!
                
                self.navigationController?.pushViewController(bandRecruitVC, animated: true)
            }
        }
    }
}
