//
//  CommunityTabView.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/06.
//

import UIKit
import Alamofire
import Kingfisher
import AVKit
import AVFoundation

class CommunityTabViewController: UIViewController {
    
    @IBOutlet weak var choiceCollectionView: UICollectionView!
    @IBOutlet weak var feedTableView: UITableView!
    
    var pofolList: [PofolResult] = []
    var thumbNailList: [String] = []
    var choice = 0
    let choiceLabel = ["전체", "팔로우"]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /* 네비바 세팅 */
    func setNavigationBar() {
        
        var leftBarButtons: [UIBarButtonItem] = []
        var rightBarButtons: [UIBarButtonItem] = []
        
        let mypageLabel = UILabel()
        mypageLabel.text = "피드"
        mypageLabel.font = UIFont(name: "Pretendard-Medium", size: 25)
        mypageLabel.textColor = .white
        
        let mypageBarButton = UIBarButtonItem(customView: mypageLabel)
        
        leftBarButtons.append(mypageBarButton)
        
        self.navigationItem.leftBarButtonItems = leftBarButtons
        
        let editingImage = UIImage(named: "ic_editing")
        let editingButton = UIButton()
        editingButton.backgroundColor = .clear
        editingButton.setImage(editingImage, for: .normal)
        editingButton.addTarget(self, action: #selector(editingAction(_:)), for: .touchUpInside)
        
        let editingBarButton = UIBarButtonItem(customView: editingButton)
        let currWidth = editingBarButton.customView?.widthAnchor.constraint(equalToConstant: 22)
        currWidth?.isActive = true
        let currHeight = editingBarButton.customView?.heightAnchor.constraint(equalToConstant: 22)
        currHeight?.isActive = true
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                             target: nil, action: nil)
        negativeSpacer.width = 15
        
        rightBarButtons.append(negativeSpacer)
        rightBarButtons.append(editingBarButton)
        
        self.navigationItem.rightBarButtonItems = rightBarButtons
        
    }
    
    @objc func editingAction(_ sender: UIButton) {
        print("피드 생성")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        choiceCollectionView.delegate = self
        choiceCollectionView.dataSource = self
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        getAllPofolList(0) {
            self.feedTableView.reloadData()
        }
    }
    

}

// MARK: API 호출 함수
extension CommunityTabViewController {
    /* 모든 포폴 리스트 */
    func getAllPofolList(_ lastPofolIdx: Int, completion: @escaping () -> Void) {
        let header: HTTPHeaders = ["Content-Type": "application/json",
                                   "x-access-token": appDelegate.jwt]
        let url = appDelegate.baseUrl + "/pofols/info/all/" + String(lastPofolIdx)
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header).responseDecodable(of: PofolData.self) { [self] response in
            switch response.result{
            case .success(let pofolData):
                pofolList = []
                pofolList = pofolData.result
                print(pofolList)
                completion()
            case .failure(let err):
                print(err.errorDescription as Any)
            }
            
        }
        
    }
    
    /* 팔로우한 유저 포폴 리스트 */
    func getFollowPofolList(_ lastPofolIdx: Int, completion: @escaping () -> Void) {
        let header: HTTPHeaders = ["Content-Type": "application/json",
                                   "x-access-token": appDelegate.jwt]
        let url = appDelegate.baseUrl + "/pofols/info/follow/" + String(lastPofolIdx)
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header).responseDecodable(of: PofolData.self) { [self] response in
            switch response.result{
            case .success(let pofolData):
                pofolList = []
                pofolList = pofolData.result
                print(pofolList)
                completion()
            case .failure(let err):
                print(err.errorDescription!)
            }
            
        }
        
    }
}

// MARK: CollectionView 설정
extension CommunityTabViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedChoiceCollectionViewCell", for: indexPath) as! FeedChoiceCollectionViewCell
        
        cell.choiceLabel.text = choiceLabel[indexPath.item]
        
        cell.layer.cornerRadius = 10
        
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
        
        if indexPath.item == 0 {
            getAllPofolList(0) {
                self.feedTableView.reloadData()
            }
        } else {
            getFollowPofolList(0) {
                self.feedTableView.reloadData()
            }
        }
        
        self.feedTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 70, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    
}

// MARK: TabelView 설정
extension CommunityTabViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pofolList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPofolTableViewCell", for: indexPath) as! MyPofolTableViewCell
        
        cell.thumbNailImg.kf.setImage(with: URL(string: (pofolList[indexPath.row].imgUrl)))
        
        cell.thumbNailImg.layer.cornerRadius = 10
        
        cell.playBtn.tag = indexPath.row
        cell.playBtn.addTarget(self, action: #selector(playBtnTapped), for: .touchUpInside)
        
        cell.nameLabel.text = pofolList[indexPath.row].nickName
        cell.titleLabel.text = pofolList[indexPath.row].title
        cell.dateLabel.text = pofolList[indexPath.row].updatedAt
        cell.descriptionLabel.text = pofolList[indexPath.row].content
        
        cell.likeLabel.text = String(pofolList[indexPath.row].pofolLikeCount!)
        cell.commentLabel.text = String(pofolList[indexPath.row].commentCount!)
        
        cell.profileImgView.kf.setImage(with: URL(string: pofolList[indexPath.row].profileImgUrl!))
        
        cell.profileImgView.layer.cornerRadius = 35/2

        
        cell.selectionStyle = .none
        
        
        cell.commentBtn.tag = pofolList[indexPath.row].pofolIdx!
        cell.commentBtn.addTarget(self, action: #selector(commentBtnTapped(sender:)), for: .touchUpInside)
        
        
        cell.likeBtn.tag = pofolList[indexPath.row].pofolIdx!
        if (pofolList[indexPath.row].likeOrNot == "Y"){
            cell.likeImg.image = UIImage(systemName: "heart.fill")
            cell.likeImg.tintColor = UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1)
            cell.likeBtn.addTarget(self, action: #selector(deleteLike(sender:)), for: .touchUpInside)
        }else{
            cell.likeImg.image = UIImage(systemName: "heart")
            cell.likeImg.tintColor = .white
            cell.likeBtn.addTarget(self, action: #selector(postLike(sender:)), for: .touchUpInside)
        }
        
        cell.menuBtn.pofolIdx = pofolList[indexPath.row].pofolIdx ?? 0
        cell.menuBtn.thumbIdx = indexPath.row
        if(appDelegate.userIdx != pofolList[indexPath.item].userIdx){
            cell.menuBtn.addTarget(self, action: #selector(menuBtnTapped), for: .touchUpInside)
        } else {
            cell.menuBtn.addTarget(self, action: #selector(myMenuBtnTapped), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 520
    }
    /* 다른 유저의 포폴 더보기 버튼 */
    @objc func menuBtnTapped(sender: PofolMenuButton){
        let optionMenu = UIAlertController(title: nil, message: "포트폴리오", preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "신고하기", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
           print("신고하기 버튼 누름")
            })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
              })
        
        optionMenu.addAction(reportAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    /* 내 포폴 더보기 버튼 */
    @objc func myMenuBtnTapped(sender: PofolMenuButton) {
        let optionMenu = UIAlertController(title: nil, message: "포트폴리오", preferredStyle: .actionSheet)
        
        let modifyAction = UIAlertAction(title: "수정하기", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
           print("수정하기 버튼 누름")
            })
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("삭제하기 버튼 누름")
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
              })
        
        optionMenu.addAction(modifyAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func playBtnTapped(sender: UIButton){
        let videoURL = URL(string: self.pofolList[sender.tag].videoUrl ?? "")!
        let player = AVPlayer(url: videoURL)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        
        self.present(playerVC, animated: true){
            player.play()
        }
    }
    
    /*좋아요 취소*/
    @objc func deleteLike(sender: UIButton){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/pofols/unlikes/" + String(sender.tag),
                   method: .delete,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success:
                print(response)
                self.getAllPofolList(0) {
                    self.feedTableView.reloadData()
                }
            default:
                return
            }
        }
    }
    
    /*좋아요 누르기*/
    @objc func postLike(sender: UIButton){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/pofols/likes/" + String(sender.tag),
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success:
                print(response)
                self.getAllPofolList(0) {
                    self.feedTableView.reloadData()
                }
            default:
                return
            }
        }
    }

    /*댓글버튼 눌렀을 때*/
    @objc func commentBtnTapped(sender: UIButton){
        guard let commentTableVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentTable") as? PorfolCommentViewController else {return}
        commentTableVC.pofolIdx = sender.tag
        self.navigationController?.pushViewController(commentTableVC, animated: true)
    }
    
}
