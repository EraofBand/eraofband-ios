//
//  OtherBandViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/19.
//

import UIKit

class OtherBandViewController: UIViewController {
    
    var userData: OtherUser?
    @IBOutlet weak var bandTableView: UITableView!
    var bandList: [GetUserBand]?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bandList = userData?.getUserBand
        
        bandTableView.delegate = self
        bandTableView.dataSource = self
        
    }

}

extension OtherBandViewController: UITableViewDelegate, UITableViewDataSource{
    
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

