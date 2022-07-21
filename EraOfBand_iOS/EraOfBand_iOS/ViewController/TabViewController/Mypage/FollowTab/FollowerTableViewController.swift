//
//  FollowerTableViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/19.
//

import UIKit
import Alamofire

class FollowerTableViewController: UIViewController{
    
    var followerUserList: [FollowUserList] = [FollowUserList(nickName: "테스트1", profileImgUrl: "", userIdx: 0), FollowUserList(nickName: "테스트2", profileImgUrl: "", userIdx: 0)]
    var filteredData: [FollowUserList] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func getFollowerList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/info/follow/" + String(appDelegate.userIdx!),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success(let obj):
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    let getData = try JSONDecoder().decode(FollowData.self, from: dataJSON)
                    
                    //print(getData)
                    self.followerUserList = (getData.result?.getfollower)!
                    //print(self.followerUserList)
                    self.filteredData = self.followerUserList
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
        getFollowerList()
        
        filteredData = followerUserList
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.barStyle = .black
        searchBar.delegate = self
    }
}

extension FollowerTableViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        
        if searchText == ""{
            filteredData = followerUserList
        }
        else{
            for i in 0...followerUserList.count - 1{
                
                if(followerUserList[i].nickName!.lowercased().contains(searchText.lowercased())){
                    filteredData.append(followerUserList[i])
                }
            }
        }
        self.tableView.reloadData()
    }
}

extension FollowerTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowTableViewCell", for: indexPath) as! FollowTableViewCell
        
        cell.nickNameLabel.text = filteredData[indexPath.row].nickName
        cell.followBtn.layer.cornerRadius = 15
        
        
        cell.profileBtn.tag = filteredData[indexPath.row].userIdx ?? 0
        cell.profileBtn.addTarget(self, action: #selector(otherUserTapped(sender:)), for: .touchUpInside)
        cell.nickNameBtn.tag = filteredData[indexPath.row].userIdx ?? 0
        cell.nickNameBtn.addTarget(self, action: #selector(otherUserTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func otherUserTapped(sender: UIButton){
        guard let otherUserVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserViewController") as? OtherUserViewController else {return}
        appDelegate.otherUserIdx = sender.tag
        otherUserVC.userIdx = sender.tag
        self.navigationController?.pushViewController(otherUserVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
