//
//  BandSearchViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/04.
//

import UIKit

class BandSearchViewController: UIViewController {

    @IBOutlet weak var bandResultTableView: UITableView!
    
    var bandResult: [bandInfo] = []
    
    @objc func bandReload(notification: NSNotification) {
        
        print("band reload Data")
        
        guard let getResult: [bandInfo] = notification.userInfo?["band"] as? [bandInfo] else { return }
        
        self.bandResult = getResult
        
        self.bandResultTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bandResultTableView.dataSource = self
        bandResultTableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(bandReload), name: .searchNotifName, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        NotificationCenter.default.removeObserver(self, name: .searchNotifName, object: nil)
    }
    

}

extension BandSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bandResult.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BandLessonSearchTableViewCell", for: indexPath) as! BandLessonSearchTableViewCell
        
        if let url = URL(string: bandResult[indexPath.item].bandImgUrl) {
            cell.repreImageView.load(url: url)
            cell.repreImageView.contentMode = .scaleAspectFill
        } else {
            cell.repreImageView.backgroundColor = .gray
        }
        
        cell.titleLabel.text = bandResult[indexPath.item].bandTitle
        
        cell.regionLabel.text = bandResult[indexPath.item].bandRegion
        
        let capacity = bandResult[indexPath.item].capacity
        let memberCount = bandResult[indexPath.item].memberCount
        cell.memberLabel.text = "\(memberCount) / \(capacity)"
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bandVC = self.storyboard?.instantiateViewController(withIdentifier: "BandRecruit") as! BandRecruitViewController
        
        let bandIdx = bandResult[indexPath.item].bandIdx
        
        GetBandInfoService.getBandInfo(bandIdx){ [self]
            (isSuccess, response) in
            if isSuccess{
                bandVC.bandInfo = response.result
                bandVC.bandIdx = bandIdx
                
                self.navigationController?.pushViewController(bandVC, animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }

}
