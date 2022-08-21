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
    
    @objc func moreButtonClicked() {
        
        let alert = UIAlertController()
        
        let deleteButton = UIAlertAction(title: "삭제하기", style: .destructive) { [self] (action) in
            deleteAlarm() { [self] in
                getAlarm() { [self] in
                    alarmTableView.reloadData()
                }
            }
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func setNavigationBar() {
        
        self.navigationItem.title = "알림"
        
        var rightBarButtons: [UIBarButtonItem] = []
        
        let moreImage = UIImage(named: "ic_more")
        let moreButton = UIButton()
        moreButton.backgroundColor = .clear
        moreButton.setImage(moreImage, for: .normal)
        moreButton.addTarget(self, action: #selector(self.moreButtonClicked), for: .touchUpInside)
        
        let moreBarButton = UIBarButtonItem(customView: moreButton)
        let currWidth = moreBarButton.customView?.widthAnchor.constraint(equalToConstant: 20)
        currWidth?.isActive = true
        let currheight = moreBarButton.customView?.heightAnchor.constraint(equalToConstant: 20)
        currheight?.isActive = true
        
        let negativeSpacer1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                             target: nil, action: nil)
        negativeSpacer1.width = 15
        
        rightBarButtons.append(negativeSpacer1)
        rightBarButtons.append(moreBarButton)
        
        self.navigationItem.rightBarButtonItems = rightBarButtons
        
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
    
    func deleteAlarm(completion: @escaping () -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let url = "\(appDelegate.baseUrl)/notice/status"
        
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        AF.request(
            url,
            method: .delete,
            encoding: JSONEncoding.default,
            headers: header
        ).responseJSON { response in
            switch response.result{
            case .success(let result):
                print(result)
                print("삭제 성공")
                completion()
            case .failure(let err):
                print(err)
                
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        
        if cellData.status == "INACTIVE" {
            cell.activeView.isHidden = true
        } else {
            cell.activeView.isHidden = false
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
