//
//  InAppAlarmViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/04.
//

import UIKit
import Alamofire

class InAppAlarmViewController: UIViewController {

    @IBOutlet weak var alarmTableView: UITableView!
    
    var alarmData: [alarmInfo] = []
    
    func setNavigationBar() {
        
        self.navigationItem.title = "알림"
        
    }
    
    func getAlarm(completion: @escaping () -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let url = "\(appDelegate.baseUrl)/notice/\(appDelegate.userIdx!)"
        
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: header
        ).responseDecodable(of: InAppAlarmData.self){ [self] response in
            switch response.result{
            case .success(let data):
                print(data)
                alarmData = data.result
                completion()
            case .failure(let err):
                print(err)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        
        getAlarm(){ [self] in
            alarmTableView.delegate = self
            alarmTableView.dataSource = self
        }
        
    }
    

}

extension InAppAlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InAppAlarmTableViewCell", for: indexPath) as! InAppAlarmTableViewCell
        
        let cellData = alarmData[indexPath.item]
        
        if let url = URL(string: cellData.noticeImg) {
            cell.alarmImageView.load(url: url)
        } else {
            cell.alarmImageView.image = UIImage(named: "default_image")
        }
        
        cell.topLabel.text = cellData.noticeHead
        cell.bottomLabel.text = cellData.noticeBody
        cell.alarmTime.text = cellData.updatedAt
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
