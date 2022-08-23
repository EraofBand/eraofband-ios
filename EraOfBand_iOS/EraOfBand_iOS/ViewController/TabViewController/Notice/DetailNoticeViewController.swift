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
    var bottomViewYValue = CGFloat(0)
    var isComment: Bool = true
    var reCommentGroupNum: Int?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setKeyBoard() {
        keyboardView.layer.cornerRadius = 20
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        cancelReCommentButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        inputButton.isEnabled = false
        inputTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func inputButtonTapped(_ sender: Any) {
        
        let content = inputTextField.text
        
        if isComment {
            postComment(content!) {
                self.commentTableView.reloadData()
            }
        } else {
            postReComment(content!, reCommentGroupNum!) {
                self.commentTableView.reloadData()
            }
        }
        
        inputTextField.text = ""
        self.view.endEditing(true)
        
    }
    
    /* 네비바 세팅 */
    func setNavigationBar() {
        
        let category = category[boardCategory!]
        self.navigationItem.title = "\(category)게시판"
        
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
                //print("boardInfo: \(boardInfoData.result)")
                boardInfoResult = boardInfoData.result
                
                boardIdx = boardInfoResult?.boardIdx
                for comment in boardInfoData.result.getBoardComments {
                    if comment.classNum == 0 {
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
                
                //print("boardComment : \(boardComments)")
                //print("groupNum : \(groupNum)")
                completion()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /* 댓글 달기 */
    func postComment(_ content: String, completion: @escaping () -> Void) {
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
        ).responseDecodable(of: BoardCommentData.self){ [self] response in
            switch response.result {
            case .success(let commentData):
                print("댓글 달기 성공")
                let commentInfo = commentData.result
                let groupNum = commentInfo.groupNum
                self.groupNum.insert(groupNum, at: 0)
                boardComments[groupNum] = [commentInfo]
                completion()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /* 대댓글 달기 */
    func postReComment(_ content: String, _ groupNum: Int, completion: @escaping () -> Void) {
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
        ).responseDecodable(of: BoardCommentData.self){ [self] response in
            switch response.result {
            case .success(let commentData):
                print("대댓글 달기 성공")
                let reCommentInfo = commentData.result
                let groupNum = reCommentInfo.groupNum
                var arr = boardComments[groupNum]
                arr!.append(reCommentInfo)
                boardComments[groupNum] = arr
                completion()
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
            for (group, comment) in boardComments {
                let index = groupNum.firstIndex(of: group)
                if section == index! + 1 {
                    return comment.count
                }
            }
        }
        
        return 0
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
            
            cell.selectionStyle = .none

            return cell
            
        } else {
            let groupNum = groupNum[indexPath.section - 1]
            
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
                cell.profileButton.tag = commentInfo.userIdx
                cell.profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
                cell.moreButton.tag = commentInfo.userIdx
                cell.moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
                
                cell.selectionStyle = .none
                
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
                
                cell.selectionStyle = .none
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}

// MARK: @objc functions
extension DetailNoticeViewController {
    @objc func profileTapped(_ sender: UIButton) {
        
        let otherUserVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUser") as! OtherUserViewController
        otherUserVC.userIdx = sender.tag
        
        self.navigationController?.pushViewController(otherUserVC, animated: true)
    }
    
    @objc func reCommentTapped(_ sender: UIButton) {
        
        print("sender tag : \(sender.tag)")
        let groupNum = groupNum[sender.tag - 1]
        let reCommentInfo = boardComments[groupNum]![0]
        let nickName = reCommentInfo.nickName
        
        self.commentTableView.scrollToRow(at: IndexPath(row: 0, section: sender.tag), at: .top, animated: true)
        
        isComment = false
        reCommentGroupNum = groupNum
        
        bottomView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        //bottomView.frame.size.height = 120
        
        print("bottomview height : \(bottomView.frame.height)")
        
        reCommentView.isHidden = false
        reCommentLabel.text = "\(nickName)님에게 답글을 남기는 중"
        
    }
    
    @objc func moreTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        if sender.tag == appDelegate.userIdx {
            let modify = UIAlertAction(title: "수정하기", style: .default) {_ in
                print("수정")
            }
            let delete = UIAlertAction(title: "삭제하기", style: .destructive) {_ in
                print("삭제")
            }
            
            actionSheet.addAction(modify)
            actionSheet.addAction(delete)
            actionSheet.addAction(cancel)
        } else {
            let declare = UIAlertAction(title: "신고하기", style: .destructive) {_ in
                let declareVC = self.storyboard?.instantiateViewController(withIdentifier: "DeclartionAlert") as! DeclarationAlertViewController
                
                declareVC.reportLocation = 6
                declareVC.reportLocationIdx = sender.tag
                declareVC.modalPresentationStyle = .fullScreen
                
                self.present(declareVC, animated: true)
            }
            
            actionSheet.addAction(declare)
            actionSheet.addAction(cancel)
        }
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    @objc func cancelTapped(_ sender: UIButton) {
        
        print("cancel Tapped")
        
        isComment = true
        
        bottomView.heightAnchor.constraint(equalToConstant: 120).isActive = false
        
        //bottomView.frame.size.height = 80
        
        print("bottomview height : \(bottomView.frame.height)")
        
        reCommentView.isHidden = true
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
            
            
//            if bottomViewYValue == 0 {
//                bottomViewYValue = self.bottomView.frame.origin.y
//            }
//
//            if bottomViewYValue == self.bottomView.frame.origin.y {
//                bottomViewYValue = self.bottomView.frame.origin.y
//                self.bottomView.frame.origin.y -= keyboardSize.height - UIApplication.shared.windows.first!.safeAreaInsets.bottom
//            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
//        self.bottomView.frame.origin.y = bottomViewYValue
        
    }
    
    @objc func textFieldDidChanged(_ sender: Any) {
        if inputTextField.text == "" {
            inputButton.isEnabled = false
        } else {
            inputButton.isEnabled = true
        }
    }
    
    /* 좋아요 post */
    @objc func postLike(_ sender: Any) {
        
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/board/likes/" + String(boardIdx!)
        
        AF.request(
            url,
            method: .post,
            encoding: JSONEncoding.default,
            headers: header
        ).response { response in
            switch response.result {
            case .success:
                self.boardInfoResult!.likeOrNot = "Y"
                self.commentTableView.reloadData()
                print("좋아요 성공")
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /* 좋아요 delete */
    @objc func deleteLike(_ sender: Any) {
        
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/board/unlikes/" + String(boardIdx!)
        
        AF.request(
            url,
            method: .delete,
            encoding: JSONEncoding.default,
            headers: header
        ).response { response in
            switch response.result {
            case .success:
                self.boardInfoResult!.likeOrNot = "N"
                self.commentTableView.reloadData()
                print("좋아요 취소 성공")
            case .failure(let err):
                print(err)
            }
        }
    }
}
