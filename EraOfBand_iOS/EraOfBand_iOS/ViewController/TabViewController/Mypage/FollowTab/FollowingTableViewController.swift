//
//  FollowingTableViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/19.
//

import UIKit
import Alamofire
import Kingfisher

class FollowingTableViewController: UIViewController{
    
    var followingUserList: [FollowUserList] = [FollowUserList(nickName: "", profileImgUrl: "", userIdx: 0)]
    var filteredData: [FollowUserList] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userIdx: Int?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func getFollowingList(){
        
        print("userIdx: \(userIdx)")
        
        GetFollowService.getFollowingList(userIdx!) { (isSuccess, getData) in
            if isSuccess {
                self.followingUserList = (getData.result?.getfollowing)!
                self.filteredData = self.followingUserList
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFollowingList()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.barStyle = .black
        searchBar.delegate = self
        
        
    }
}

extension FollowingTableViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        
        if searchText == ""{
            filteredData = followingUserList
        }
        else{
            for i in 0...followingUserList.count - 1{
                
                if(followingUserList[i].nickName!.lowercased().contains(searchText.lowercased())){
                    filteredData.append(followingUserList[i])
                }
            }
        }
        self.tableView.reloadData()
    }
}

extension FollowingTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowTableViewCell", for: indexPath) as! FollowTableViewCell
        
        cell.nickNameLabel.text = filteredData[indexPath.row].nickName
        cell.profileImgView.kf.setImage(with: URL(string: filteredData[indexPath.row].profileImgUrl ?? ""))
        cell.profileImgView.layer.cornerRadius = 20
        
        cell.followBtn.layer.cornerRadius = 15
        /*
        if userIdx == appDelegate.userIdx {
            //cell.followBtn.isHidden = false
            
        }*/
        
        if filteredData[indexPath.row].follow == 0{
            
            cell.followBtn.setTitle("팔로우", for: .normal)
            cell.followBtn.backgroundColor = UIColor(named: "on_icon_color")
        }else{
            
            cell.followBtn.setTitle("팔로잉", for: .normal)
            cell.followBtn.backgroundColor = UIColor(named: "unfollow_btn_color")
        }


        cell.followBtn.tag = indexPath.row
        cell.followBtn.addTarget(self, action: #selector(followBtnTapped(sender:)), for: .touchUpInside)
        
        cell.profileBtn.tag = filteredData[indexPath.row].userIdx!
        cell.profileBtn.addTarget(self, action: #selector(otherUserTapped(sender:)), for: .touchUpInside)
        cell.nickNameBtn.tag = filteredData[indexPath.row].userIdx!
        cell.nickNameBtn.addTarget(self, action: #selector(otherUserTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    /*팔로우 버튼 눌렀을 때 실행*/
    @objc func followBtnTapped(sender: UIButton){
        var targetIndexPath = sender.tag
        
        //팔로우 여부에 따라 팔로우/언팔로우 함수 호출
        if(filteredData[targetIndexPath].follow == 0){
            doFollow(targetIdx: filteredData[targetIndexPath].userIdx ?? 0, targetIndexPath: targetIndexPath)
        }else{
            doUnFollow(targetIdx: filteredData[targetIndexPath].userIdx ?? 0, targetIndexPath: targetIndexPath)
        }
    }
    
    func doUnFollow(targetIdx: Int, targetIndexPath: Int){
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
                self.filteredData[targetIndexPath].follow = 0
                for i in 0..<self.followingUserList.count{
                    if(self.filteredData[targetIndexPath].userIdx == self.followingUserList[i].userIdx){
                        self.followingUserList[i].follow = 0
                    }
                }
                self.tableView.reloadData()
            default:
                return
            }
        }
    }
    
    func doFollow(targetIdx: Int, targetIndexPath: Int){
        
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
                self.filteredData[targetIndexPath].follow = 1
                for i in 0..<self.followingUserList.count{
                    if(self.filteredData[targetIndexPath].userIdx == self.followingUserList[i].userIdx){
                        self.followingUserList[i].follow = 1
                    }
                }
                self.tableView.reloadData()
            default:
                return
            }
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

