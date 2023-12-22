//
//  FreeBoardViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/16.
//

import UIKit
import Alamofire

class FreeBoardViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    var postList: [BoardListResult] = []
    
    var refreshControl = UIRefreshControl()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    
    func getPostList(boardIdx: Int, completion: @escaping ()-> Void){
        let header : HTTPHeaders = [
            "x-access-token": defaults.string(forKey: "jwt")!,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/board/list/info/0/" + String(boardIdx),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: BoardListModel.self){
            response in
            switch response.result{
            case .success(let data):
                self.postList += data.result
                completion()
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPostList(boardIdx: 0){ 
            self.tableView.reloadData()
        }
        
        /*리프레쉬 세팅*/
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        getPostList(boardIdx: 0){
            self.tableView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getPostList(boardIdx: 0){
            self.tableView.reloadData()
        }
    }
}

extension FreeBoardViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath) as! BoardTableViewCell
        
        cell.title.text = postList[indexPath.row].title
        cell.content.text = postList[indexPath.row].content
        cell.nickname.text = postList[indexPath.row].nickName
        cell.updatedAt.text = postList[indexPath.row].updatedAt
        cell.viewCount.text = "조회수 " + String(postList[indexPath.row].views)
        cell.likeNum.text = String(postList[indexPath.row].boardLikeCount)
        cell.commentNum.text = String(postList[indexPath.row].commentCount)
        
        
        if(postList[indexPath.row].imgUrl != "null" && postList[indexPath.row].imgUrl != ""){
            cell.postImgView.load(url: URL(string: postList[indexPath.row].imgUrl)!)
        }
        cell.postImgView.layer.cornerRadius = 5
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailNotice") as! DetailNoticeViewController
        
        detailVC.boardIdx = postList[indexPath.item].boardIdx
        detailVC.boardCategory = 0
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

/*
extension FreeBoardViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentListSize = self.postList.count
        
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height){
            //print("called")
            getPostList(boardIdx: postList[postList.count - 1].boardIdx){ data in
                for i in 0..<data.result.count{
                    self.postList.append(data.result[i])
                }
                if(currentListSize != self.postList.count){
                    self.tableView.reloadData()
                }
            }
        }
    }
}*/

