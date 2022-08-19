//
//  MyBoardViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/17.
//

import UIKit
import Alamofire

class MyBoardViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var postList: [MyPostResult] = [MyPostResult(boardIdx: 0, boardLikeCount: 0, category: 0, commentCount: 0, title: "", updatedAt: "", views: 0)]
    
    var choice = 0
    let choiceLabel = ["작성 글","댓글 단 글"]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //작성 글 리스트 불러오기
    func getMyPostList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/board/my",
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: MyPostListModel.self){
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
    
    //댓글 단 글 리스트 불러오기
    func getMyCommentList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/board/my-comment",
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: MyPostListModel.self){
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getMyPostList()
    }
    
}

extension MyBoardViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBoardTableViewCell", for: indexPath) as! MyBoardTableViewCell
        
        cell.title.text = postList[indexPath.row].title
        cell.updatedAt.text = postList[indexPath.row].updatedAt
        cell.viewCount.text = "조회수 " + String(postList[indexPath.row].views)
        
        switch(postList[indexPath.row].category){
        case 0:
            cell.boardName.text = "자유게시판"
            break
        case 1:
            cell.boardName.text = "질문게시판"
            break
        case 2:
            cell.boardName.text = "홍보게시판"
            break
        case 3:
            cell.boardName.text = "거래게시판"
            break
        default:
            break
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
}

extension MyBoardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedChoiceCollectionViewCell", for: indexPath) as! FeedChoiceCollectionViewCell
        
        cell.choiceLabel.text = choiceLabel[indexPath.item]
        
        cell.layer.cornerRadius = 15
        
        if indexPath.item == choice {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        } else {
            cell.isSelected = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        choice = indexPath.item
        postList = []
        
        if indexPath.item == 0 {
            getMyPostList()
        } else {
            getMyCommentList()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: choiceLabel[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont(name: "Pretendard-Medium", size: 14)]).width + 30, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
    
}


