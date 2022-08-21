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
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var reCommentView: UIView!
    @IBOutlet weak var reCommentLabel: UILabel!
    @IBOutlet weak var cancelReCommentButton: UIButton!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let category = ["자유", "질문", "홍보", "거래"]
    
    var boardCategory: Int?
    var boardIdx: Int?
    var boardInfoResult: boardInfoResult?
    var boardComments: [Int : [boardCommentsInfo]] = [:]
    var groupNum: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyBoard()
        
        setNavigationBar()
        
        getBoardInfo() { [self] in
            commentTableView.delegate = self
            commentTableView.dataSource = self
            
            commentTableView.rowHeight = UITableView.automaticDimension
            commentTableView.estimatedRowHeight = 90
        }
        
    }
    
    func setKeyBoard() {
        keyboardView.layer.cornerRadius = 20
        
        inputButton.addTarget(self, action: #selector(commentInputTapped), for: .touchUpInside)
    }
    
    /* 네비바 세팅 */
    func setNavigationBar() {
        
        let category = category[boardCategory!]
        self.navigationItem.title = "\(category)게시판"
        
        var rightBarButtons: [UIBarButtonItem] = []
        
        let moreImage = UIImage(named: "ic_more")
        let moreButton = UIButton()
        moreButton.backgroundColor = .clear
        moreButton.setImage(moreImage, for: .normal)
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        
        let moreBarButton = UIBarButtonItem(customView: moreButton)
        let currWidth = moreBarButton.customView?.widthAnchor.constraint(equalToConstant: 4)
        currWidth?.isActive = true
        let currHeight = moreBarButton.customView?.heightAnchor.constraint(equalToConstant: 16)
        currHeight?.isActive = true
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                             target: nil, action: nil)
        negativeSpacer.width = 15
        
        rightBarButtons.append(negativeSpacer)
        rightBarButtons.append(moreBarButton)
        
        self.navigationItem.rightBarButtonItems = rightBarButtons
        
        
    }

}

// MARK: API 호출
extension DetailNoticeViewController {
    /* 게시물 정보 호출 */
    func getBoardInfo(completion: @escaping () -> Void) {
        
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/board/info/" + String(boardIdx!)
        
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: header
        ).responseDecodable(of: BoardInfoData.self){ [self] response in
            
            switch response.result{
            case .success(let boardInfoData):
                print("boardInfo: \(boardInfoData.result)")
                boardInfoResult = boardInfoData.result
                
                for comment in boardInfoData.result.getBoardComments {
                    if comment.classNum == 0 { // 기본 댓글일 경우 boardComment에 추가
                        groupNum.append(comment.groupNum)
                        if var arr = boardComments[comment.groupNum] {
                            arr.insert(comment, at: 0)
                            boardComments[comment.groupNum] = arr
                        } else {
                            boardComments[comment.groupNum] = [comment]
                        }
                    } else { // 대댓글일 경우 boardReComments에 추가
                        if var arr = boardComments[comment.groupNum] {
                            arr.append(comment)
                            boardComments[comment.groupNum] = arr
                        } else {
                            boardComments[comment.groupNum] = [comment]
                        }
                    }
                }
                
                print("boardComment : \(boardComments)")
                print("groupNum : \(groupNum)")
                completion()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /* 댓글 달기 */
    func postComment(_ content: String) {
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/board/comment/" + String(boardIdx!)
        let params = ["content": content, "userIdx": appDelegate.userIdx!] as Dictionary
        
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: header
        ).responseDecodable(of: boardCommentsInfo.self){ response in
            switch response.result {
            case .success:
                print("댓글 달기 성공")
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /* 대댓글 달기 */
    func postReComment(_ content: String, _ groupNum: Int) {
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/board/re-comment/" + String(boardIdx!)
        let params = ["content": content, "groupNum": groupNum, "userIdx": appDelegate.userIdx!] as Dictionary
        
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: header
        ).responseDecodable(of: boardCommentsInfo.self){ response in
            switch response.result {
            case .success:
                print("대댓글 달기 성공")
            case .failure(let err):
                print(err)
            }
        }
    }
    
}

// MARK: tableView 세팅
extension DetailNoticeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return boardComments.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let groupNum = groupNum[section]
            let commentCount = boardComments[groupNum]?.count
            
            print("section \(section) : \(commentCount!)")
            
            return commentCount!
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section ==  0 { // 게시물 내용 section
            let cell = tableView.dequeueReusableCell(withIdentifier: BoardDetailTableViewCell.identifier) as! BoardDetailTableViewCell
            
            cell.boardImageDataSource.boardImage = boardInfoResult!.getBoardImgs
            
            if boardInfoResult!.getBoardImgs.count == 0 {
                cell.noticeImgView.isHidden = true
            } else {
                cell.registerDelegate()
                cell.registerXib()
                
                cell.imgPageControl.numberOfPages = boardInfoResult!.getBoardImgs.count
            }

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
            cell.ectLabel.text = "좋아요 \(likeCount)  댓글 \(commentCount)  조회수 \(viewCount)"

            if boardInfoResult!.likeOrNot == "Y" {
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.likeButton.addTarget(self, action: #selector(deleteLike), for: .touchUpInside)
            } else {
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.likeButton.addTarget(self, action: #selector(postLike), for: .touchUpInside)
            }

            return cell
            
        } else {
            let groupNum = groupNum[indexPath.section]
            
            if indexPath.row == 0 { // 게시물 댓글 cell
                let cell = tableView.dequeueReusableCell(withIdentifier: BoardCommentTableViewCell.identifier, for: indexPath) as! BoardCommentTableViewCell
                
                let commentInfo = boardComments[groupNum]![0]
                
                if let url = URL(string: commentInfo.profileImgUrl) {
                    cell.userImageView.load(url: url)
                } else {
                    cell.userImageView.image = UIImage(named: "default_image")
                }
                
                cell.nicknameLabel.text = commentInfo.nickName
                cell.commentLabel.text = commentInfo.content
                cell.updateAtLabel.text = commentInfo.updatedAt
                
                cell.reCommentButton.tag = indexPath.section
                cell.reCommentButton.addTarget(self, action: #selector(reCommentTapped), for: .touchUpInside)
                cell.profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
                cell.moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
                
                return cell
            } else { // 게시물 대댓글 cell
                let cell = tableView.dequeueReusableCell(withIdentifier: BoardReCommentTableViewCell.identifier, for: indexPath) as! BoardReCommentTableViewCell
                
                let commentInfo = boardComments[groupNum]![indexPath.row]
                
                if let url = URL(string: commentInfo.profileImgUrl) {
                    cell.profileImageView.load(url: url)
                } else {
                    cell.profileImageView.image = UIImage(named: "default_image")
                }
                
                cell.userNicknameLabel.text = commentInfo.nickName
                cell.contentLabel.text = commentInfo.content
                cell.updateAtLabel.text = commentInfo.updatedAt
                
                return cell
            }
            
        }
    }
    
}

// MARK: @objc functions
extension DetailNoticeViewController {
    @objc func profileTapped(_ sender: UIButton) {
        
    }
    
    @objc func commentInputTapped(_ sender: UIButton) {
        let content = inputTextField.text
        
        postComment(content!)
    }
    
    @objc func reCommentInputTapped(_ sender: UIButton) {
        let content = inputTextField.text
        let groupNum = groupNum[sender.tag]
        
        postReComment(content!, groupNum)
    }
    
    @objc func reCommentTapped(_ sender: UIButton) {
        
        let reCommetInfo = boardComments[sender.tag]![0]
        let nickName = reCommetInfo.nickName
        
        bottomView.height += 50
        reCommentView.isHidden = false
        reCommentLabel.text = "\(nickName)님에게 답글을 남기는 중"
        
        inputButton.tag = sender.tag
        inputButton.addTarget(self, action: #selector(reCommentInputTapped), for: .touchUpInside)
        
        cancelReCommentButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
    }
    
    @objc func moreTapped(_ sender: UIButton) {
        
    }
    
    @objc func cancelTapped(_ sender: UIButton) {
        
        bottomView.height -= 50
        reCommentView.isHidden = true
        
        inputButton.addTarget(self, action: #selector(commentInputTapped), for: .touchUpInside)
        
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
