//
//  DetailNoticeViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/16.
//

import UIKit
import Alamofire

class DetailNoticeViewController: UIViewController {

    @IBOutlet weak var commentTableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var boardInfoResult: boardInfoResult?
    var boardComments: [boardCommentsInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        let boardHeaderCell = UINib(nibName: BoardDetailTableViewCell.identifier, bundle: nil)
        commentTableView.register(boardHeaderCell, forCellReuseIdentifier: BoardDetailTableViewCell.identifier)
        
    }

}

// MARK: API 호출
extension DetailNoticeViewController {
    /* 게시물 정보 호출 */
    func getBoardInfo(_ boardIdx: Int, completion: @escaping () -> Void) {
        
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/board/info/" + String(boardIdx)
        
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: header
        ).responseDecodable(of: BoardInfoData.self){ response in
            
            switch response.result{
            case .success(let boardInfoData):
                self.boardInfoResult = boardInfoData.result
                self.boardComments = self.boardInfoResult!.getBoardComments
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /* 좋아요 post */
    @objc func postLike(_ boardIdx: Int) {
        
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/board/likes/" + String(boardIdx)
        
        AF.request(
            url,
            method: .post,
            encoding: JSONEncoding.default,
            headers: header
        ).response { response in
            switch response.result {
            case .success:
                print("좋아요 성공")
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /* 좋아요 delete */
    @objc func deleteLike(_ boardIdx: Int) {
        
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/board/unlikes/" + String(boardIdx)
        
        AF.request(
            url,
            method: .delete,
            encoding: JSONEncoding.default,
            headers: header
        ).response { response in
            switch response.result {
            case .success:
                print("좋아요 취소 성공")
            case .failure(let err):
                print(err)
            }
        }
    }
}

// MARK: tableView 세팅
extension DetailNoticeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return boardComments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: BoardDetailTableViewCell.identifier) as! BoardDetailTableViewCell
            
            if let url = URL(string: boardInfoResult!.profileImgUrl) {
                cell.userImageView.load(url: url)
            } else {
                cell.userImageView.image = UIImage(named: "default_image")
            }
            
            cell.userNicknameLabel.text = boardInfoResult!.nickName
            cell.userTimeLabel.text = boardInfoResult!.updatedAt
            cell.titleLabel.text = boardInfoResult!.title
            cell.contentLabel.text = boardInfoResult!.content
            
            let likeCount = boardInfoResult!.boardLikeCount
            let commentCount = boardInfoResult!.getBoardComments.count
            let viewCount = boardInfoResult!.views
            cell.ectLabel.text = "좋아요\(likeCount) 댓글\(commentCount) 조회수\(viewCount)"
            
            if boardInfoResult!.likeOrNot == "Y" {
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.likeButton.addTarget(self, action: #selector(deleteLike), for: .touchUpInside)
            } else {
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.likeButton.addTarget(self, action: #selector(postLike), for: .touchUpInside)
            }
            
            if boardInfoResult!.getBoardImgs.count == 0 {
                cell.noticeImgView.height = 0
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCommentTableViewCell", for: indexPath) as! BoardCommentTableViewCell
            
            return cell
            
        default:
            return UITableViewCell()
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
    }
    
}
