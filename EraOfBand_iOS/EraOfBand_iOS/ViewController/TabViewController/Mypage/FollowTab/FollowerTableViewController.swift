//
//  FollowerTableViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/19.
//

import UIKit
import Alamofire

class FollowerTableViewController: UIViewController{
    
    var followerUserList: [FollowUserList] = [FollowUserList(nickName: "", profileImgUrl: "", userIdx: 0)]
    var filteredData: [FollowUserList] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userIdx: Int?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func getFollowerList(){
        
        print("userIdx: \(userIdx)")
        
        GetFollowService.getFollowerList(userIdx!) { (isSuccess, getData) in
            if isSuccess {
                self.followerUserList = (getData.result?.getfollower)!
                self.filteredData = self.followerUserList
                self.tableView.reloadData()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
        
        cell.profileImgView.kf.setImage(with: URL(string: filteredData[indexPath.row].profileImgUrl ?? ""))
        cell.profileImgView.layer.cornerRadius = 20
        
        if userIdx == appDelegate.userIdx {
            cell.followBtn.isHidden = false
            cell.followBtn.layer.cornerRadius = 15
        }
        
        
        if filteredData[indexPath.row].follow == 0{
            
            cell.followBtn.setTitle("팔로우", for: .normal)
            cell.followBtn.backgroundColor = UIColor(named: "on_icon_color")
            cell.followBtn.addAction(for: .touchUpInside){
                self.doFollow(targetIdx: self.filteredData[indexPath.row].userIdx!, completion: {
                    //cell.followBtn.titleLabel?.text = "팔로잉"
                    print("현재 언팔 상태")
                    cell.followBtn.setTitle("팔로잉", for: .normal)
                    cell.followBtn.backgroundColor = UIColor(named: "unfollow_btn_color")
                    self.filteredData[indexPath.row].follow = 1
                })
            }
        }else{
            
            //cell.followBtn.titleLabel?.text = "팔로잉"
            cell.followBtn.setTitle("팔로잉", for: .normal)
            cell.followBtn.backgroundColor = UIColor(named: "unfollow_btn_color")
            cell.followBtn.addAction(for: .touchUpInside){
                self.doUnFollow(targetIdx: self.filteredData[indexPath.row].userIdx!, completion: {
                    //cell.followBtn.titleLabel?.text = "팔로우"
                    print("현재 팔로 상태")
                    cell.followBtn.setTitle("팔로우", for: .normal)
                    cell.followBtn.backgroundColor = UIColor(named: "on_icon_color")
                    self.filteredData[indexPath.row].follow = 0
                })
            }
        }
    
        cell.profileBtn.tag = filteredData[indexPath.row].userIdx ?? 0
        cell.profileBtn.addTarget(self, action: #selector(otherUserTapped(sender:)), for: .touchUpInside)
        cell.nickNameBtn.tag = filteredData[indexPath.row].userIdx ?? 0
        cell.nickNameBtn.addTarget(self, action: #selector(otherUserTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func otherUserTapped(sender: UIButton){
        guard let otherUserVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserViewController") as? OtherUserViewController else {return}
        
        GetOtherUserDataService.getOtherUserInfo(sender.tag){ [self]
            (isSuccess, response) in
            if isSuccess{
                otherUserVC.userData = response.result
                otherUserVC.userIdx = sender.tag
                self.navigationController?.pushViewController(otherUserVC, animated: true)
            }
            
        }
    }
    
    func doUnFollow(targetIdx: Int, completion: @escaping() -> Void){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/unfollow/" + String(targetIdx),
                   method: .delete,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success:
                completion()
            default:
                return
            }
        }
    }
    
    func doFollow(targetIdx: Int, completion: @escaping() -> Void){
        
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/follow/" + String(targetIdx),
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success:
                completion()
            default:
                return
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    }
}
