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
    
    var postList: [BoardListResult] = [BoardListResult(boardIdx: 0, boardLikeCount: 0, category: 0, commentCount: 0, content: "내용", nickName: "닉네임", title: "제목", updatedAt: "1일 전", userIdx: 0, views: 0),BoardListResult(boardIdx: 0, boardLikeCount: 0, category: 0, commentCount: 0, content: "내용", nickName: "닉네임", title: "제목", updatedAt: "1일 전", userIdx: 0, views: 0)]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getPostList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/board/list/info/0/0",
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: BoardListModel.self){
            response in
            switch response.result{
            case .success(let data):
                self.postList = data.result
                self.tableView.reloadData()
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPostList()
        
        tableView.delegate = self
        tableView.dataSource = self
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
        
        /*
        if(postList[indexPath.row].imgUrl != ""){
            cell.postImgView.load(url: URL(string: postList[indexPath.row].imgUrl)!)
        }*/
        cell.postImgView.layer.cornerRadius = 5
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
}
