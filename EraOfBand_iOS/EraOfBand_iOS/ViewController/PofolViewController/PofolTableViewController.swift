//
//  PofolTableViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/14.
//

import UIKit
import Alamofire

class PofolTableViewController: UIViewController{
    
    var pofolList: [PofolResult] = [PofolResult(commentCount: 0, content: "", likeOrNot: "", nickName: "", pofolIdx: 0, pofolLikeCount: 0, profileImgUrl: "", title: "", updatedAt: "", userIdx: 0, videoUrl: "")]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getPofolList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        //print(appDelegate.baseUrl + "/pofol/my/" + "?userIdx=" + String(appDelegate.userIdx!))
        
        AF.request(appDelegate.baseUrl + "/pofol/my/" + "?userIdx=" + String(appDelegate.userIdx!),
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
                    //print(getData)
                    self.pofolList = getData.result
                    print(self.pofolList)
                    self.tableView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            default:
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "포트폴리오"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        getPofolList()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension PofolTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pofolList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPofolTableViewCell", for: indexPath) as! MyPofolTableViewCell
        
        //cell.profileImgView.image = pofolList[indexPath.row].profileImgUrl
        
        cell.nameLabel.text = pofolList[indexPath.row].nickName
        cell.titleLabel.text = pofolList[indexPath.row].title
        cell.dateLabel.text = pofolList[indexPath.row].updatedAt
        cell.descriptionLabel.text = pofolList[indexPath.row].content
        
        //cell.likeLabel.text = String(pofolList[indexPath.row].pofolLikeCount)
        //cell.commentLabel.text = String(pofolList[indexPath.row].pofolLikeCount)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 538
    }
}
