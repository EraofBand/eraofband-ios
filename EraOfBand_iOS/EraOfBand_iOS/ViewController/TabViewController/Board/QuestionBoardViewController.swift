//
//  QuestionBoardViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/17.
//

import UIKit
import Alamofire

class QuestionBoardViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    var postList: [BoardListResult] = [BoardListResult(boardIdx: 0, boardLikeCount: 0, category: 0, commentCount: 0, content: "내용", imgUrl: "", nickName: "닉네임", title: "제목", updatedAt: "1일 전", userIdx: 0, views: 0),BoardListResult(boardIdx: 0, boardLikeCount: 0, category: 0, commentCount: 0, content: "내용", imgUrl: "", nickName: "닉네임", title: "제목", updatedAt: "1일 전", userIdx: 0, views: 0)]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getPostList(boardIdx: Int, completion: @escaping (BoardListModel)-> Void){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/board/list/info/1/" + String(boardIdx),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: BoardListModel.self){
            response in
            switch response.result{
            case .success(let data):
                completion(data)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPostList(boardIdx: 0){ data in
            self.postList = data.result
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getPostList(boardIdx: 0){ data in
            self.postList = data.result
            self.tableView.reloadData()
        }
    }
    
}

extension QuestionBoardViewController: UITableViewDataSource, UITableViewDelegate{
    
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
}

extension QuestionBoardViewController: UIScrollViewDelegate{
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
}
