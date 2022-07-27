//
//  BandListTableViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/26.
//

import UIKit

class BandListTableViewController: UIViewController {
    
    @IBOutlet weak var bandTableView: UITableView!
    
    var tabNum: Int?
    var region: String?
    var bandList: [bandInfo] = []

    func getBandList() {
        
        GetBandListService.getBandInfoList(region!, String(tabNum!)) { [self] (isSuccess, response) in
            if isSuccess {
                bandList = response.result
                
                bandTableView.delegate = self
                bandTableView.dataSource = self
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBandList()
        
    }
    
}

extension BandListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bandList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BandListTableViewCell", for: indexPath) as! BandListTableViewCell
        
        cell.backgroundColor = .clear
        
        let bandinfo = bandList[indexPath.item]
        let url = URL(string: bandinfo.bandImgUrl)!
        cell.bandImageView.load(url: url)
        cell.districtLabel.text = bandinfo.bandRegion
        cell.bandNameLabel.text = bandinfo.bandTitle
        cell.bandIntroLabel.text = bandinfo.bandIntroduction
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    

}
