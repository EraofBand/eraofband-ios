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
    var loadCount = 0
    let choiceLabel = ["전체", "팔로우"]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var modifyIdx = 0
    
    var refreshControl = UIRefreshControl()
    
    /* 네비바 세팅 */
    func setNavigationBar() {
        self.navigationController?.navigationBar.clipsToBounds = true //네비게이션 바 밑 보더 지우기
        
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
        let addPofolVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPofol") as! AddPofolViewController
        
        self.navigationController?.pushViewController(addPofolVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        choiceCollectionView.delegate = self
        choiceCollectionView.dataSource = self
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        /*리프레쉬 세팅*/
        feedTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        getAllPofolList(0) {
            self.feedTableView.reloadData()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        self.pofolList = []
        if self.choice == 0 {
            self.getAllPofolList(0) {
                self.feedTableView.reloadData()
            }
        } else {
            self.getFollowPofolList(0) {
                self.feedTableView.reloadData()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.feedTableView.refreshControl?.endRefreshing()
            self.feedTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
                pofolList += pofolData.result
                for name in pofolList {
                    print("\(name.userIdx!)", terminator: " ")
                }
                print("")
                print("pofolCount : \(self.pofolList.count)")
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
                pofolList += pofolData.result
                for name in pofolList {
                    print("\(name.userIdx!)", terminator: " ")
                }
                print("")
                print("pofolCount : \(self.pofolList.count)")
                completion()
            case .failure(let err):
                print(err.errorDescription!)
            }
            
        }
        
    }
    
    func deletePofol(pofolIdx: Int){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request("https://eraofband.shop/pofols/status/" + String(pofolIdx),
                   method: .patch,
                   parameters: [
                    "userIdx": appDelegate.userIdx!
                   ],
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch(response.result){
            case.success :
                self.pofolList = []
                if self.choice == 0 {
                    self.getAllPofolList(0) {
                        self.feedTableView.reloadData()
                    }
                } else {
                    self.getFollowPofolList(0) {
                        self.feedTableView.reloadData()
                    }
                }
            default:
                return
            }
            
        }
    }
    
    func modifyPofol(pofolIdx: Int, thumbIdx: Int){
        guard let addPofolVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPofolViewController") as? AddPofolViewController else {return}
                
        addPofolVC.isModifying = true
        addPofolVC.currentTitle = pofolList[thumbIdx].title ?? ""
        addPofolVC.currentDescription = pofolList[thumbIdx].content ?? ""
        addPofolVC.currentThumbNailUrl = pofolList[thumbIdx].imgUrl
        addPofolVC.pofolIdx = pofolIdx
        
        self.navigationController?.pushViewController(addPofolVC, animated: true)
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
        pofolList = []
        
        if indexPath.item == 0 {
            getAllPofolList(0) {
                self.feedTableView.reloadData()
                self.feedTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        } else {
            getFollowPofolList(0) {
                self.feedTableView.reloadData()
                self.feedTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
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
        cell.thumbNailView.layer.cornerRadius = 10
        
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
        
        if pofolList[indexPath.row].userIdx != appDelegate.userIdx {
            cell.profileBtn.tag = pofolList[indexPath.row].userIdx!
            cell.profileBtn.isEnabled = true
            cell.profileBtn.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        } else {
            cell.profileBtn.isEnabled = false
        }

        cell.selectionStyle = .none
        
        
        cell.commentBtn.tag = pofolList[indexPath.row].pofolIdx!
        cell.commentBtn.addTarget(self, action: #selector(commentBtnTapped(sender:)), for: .touchUpInside)
        
        
        cell.likeBtn.tag = indexPath.row
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
        
        print("cell: \(pofolList[indexPath.item].userIdx!)")
        if(appDelegate.userIdx == pofolList[indexPath.row].userIdx){
            cell.menuBtn.addTarget(self, action: #selector(myMenuBtnTapped(sender:)), for: .touchUpInside)
        }else{
            cell.menuBtn.addTarget(self, action: #selector(menuBtnTapped(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 520
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == pofolList.count {
            if (loadCount % 2 != 0) || (loadCount == 0) {
                print("가져와")
                let pofolIdx = pofolList[indexPath.row].pofolIdx
                if choice == 0 {
                    getAllPofolList(pofolIdx!) {
                        self.feedTableView.reloadData()
                    }
                } else {
                    getFollowPofolList(pofolIdx!) {
                        self.feedTableView.reloadData()
                    }
                }
            }
            loadCount += 1
        }
    }
    
    /* 다른 유저 프로필 클릭 */
    @objc func profileTapped(sender: UIButton) {
        let otherUserIdx = sender.tag
        print("otherUserIdx: \(otherUserIdx)")
        
        guard let otherVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUser") as? OtherUserViewController else { return }
        
        GetOtherUserDataService.getOtherUserInfo(otherUserIdx){ [self]
            (isSuccess, response) in
            if isSuccess{
                otherVC.userData = response.result
                otherVC.userIdx = otherUserIdx
                self.navigationController?.pushViewController(otherVC, animated: true)
            }
            
        }
    }
    
    /* 다른 유저의 포폴 더보기 버튼 */
    @objc func menuBtnTapped(sender: PofolMenuButton){
        let optionMenu = UIAlertController(title: nil, message: "포트폴리오", preferredStyle: .actionSheet)
        
        let declareAction = UIAlertAction(title: "신고하기", style: .destructive) {_ in
            let declareVC = self.storyboard?.instantiateViewController(withIdentifier: "DeclartionAlert") as! DeclarationAlertViewController
            
            declareVC.reportLocation = 1
            declareVC.reportLocationIdx = sender.tag
            declareVC.modalPresentationStyle = .overCurrentContext
            
            self.present(declareVC, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
              })
        
        optionMenu.addAction(declareAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    /* 내 포폴 더보기 버튼 */
    @objc func myMenuBtnTapped(sender: PofolMenuButton) {
        let optionMenu = UIAlertController(title: nil, message: "포트폴리오", preferredStyle: .actionSheet)
        
        let modifyAction = UIAlertAction(title: "수정하기", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
            self.modifyPofol(pofolIdx: sender.pofolIdx ?? 0, thumbIdx: sender.thumbIdx ?? 0)
            })
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.deletePofol(pofolIdx: sender.pofolIdx ?? 0)
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
        let pofolIdx = pofolList[sender.tag].pofolIdx!
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/pofols/unlikes/" + String(pofolIdx),
                   method: .delete,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success:
                print(response)
                self.pofolList[sender.tag].likeOrNot = "N"
                self.pofolList[sender.tag].pofolLikeCount! -= 1
                self.feedTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
            default:
                return
            }
        }
    }
    
    /*좋아요 누르기*/
    @objc func postLike(sender: UIButton){
        let pofolIdx = pofolList[sender.tag].pofolIdx!
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/pofols/likes/" + String(pofolIdx),
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success:
                print(response)
                self.pofolList[sender.tag].likeOrNot = "Y"
                self.pofolList[sender.tag].pofolLikeCount! += 1
                self.feedTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
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
