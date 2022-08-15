//
//  PofolTableViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/14.
//

import UIKit
import Alamofire
import Kingfisher
import AVKit
import AVFoundation

class PofolTableViewController: UIViewController{
    
    var pofolList: [PofolResult] = [PofolResult(commentCount: 0, content: "", likeOrNot: "", nickName: "", pofolIdx: 0, pofolLikeCount: 0, profileImgUrl: "", title: "", updatedAt: "", userIdx: 0, videoUrl: "")]
    
    var thumbNailList: [String] = [""]
    
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userIdx: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*좋아요 업데이트를 위한 포폴리스트 리로드 함수*/
    func reloadPofolList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/pofols/info/" + String(self.userIdx),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success(let obj):
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj,
                                           options: .prettyPrinted)
                    let getData = try JSONDecoder().decode(PofolData.self, from: dataJSON)
                    self.pofolList = getData.result
                    self.tableView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            default:
                return
            }
        }
    }
    
    /*뷰 최초 실행시 포폴리스트 가져오기 함수*/
    func getPofolList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        //print(appDelegate.baseUrl + "/pofol/my/" + "?userIdx=" + String(appDelegate.userIdx!))
        
        AF.request(appDelegate.baseUrl + "/pofols/info/" + String(self.userIdx),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success(let obj):
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj,
                                           options: .prettyPrinted)
                    let getData = try JSONDecoder().decode(PofolData.self, from: dataJSON)
                    //print(response)
                    self.pofolList = getData.result
                    print(self.pofolList)
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: self.selectedIndex, at: .top, animated: true)
                }catch{
                    print(error.localizedDescription)
                }
            default:
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "포트폴리오"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        getPofolList()
        
        print(thumbNailList)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        reloadPofolList()
    }
}

extension PofolTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pofolList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPofolTableViewCell", for: indexPath) as! MyPofolTableViewCell
        
        cell.thumbNailImg.kf.setImage(with: URL(string: (thumbNailList[indexPath.row])))
        
        cell.thumbNailView.layer.cornerRadius = 10
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
        if(appDelegate.userIdx == pofolList[indexPath.row].userIdx){
            cell.menuBtn.addTarget(self, action: #selector(menuBtnTapped(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    func deletePofol(pofolIdx: Int, thumbIdx: Int){
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
                self.thumbNailList.remove(at: thumbIdx)
                self.reloadPofolList()
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
        addPofolVC.currentThumbNailUrl = thumbNailList[thumbIdx]
        addPofolVC.pofolIdx = pofolIdx
        
        self.navigationController?.pushViewController(addPofolVC, animated: true)
    }
    
    @objc func menuBtnTapped(sender: PofolMenuButton){
        let optionMenu = UIAlertController(title: nil, message: "포트폴리오", preferredStyle: .actionSheet)
        
        let modifyAction = UIAlertAction(title: "수정하기", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
            self.modifyPofol(pofolIdx: sender.pofolIdx ?? 0, thumbIdx: sender.thumbIdx ?? 0)
            })
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive, handler: {
                    (alert: UIAlertAction!) -> Void in
            self.deletePofol(pofolIdx: sender.pofolIdx ?? 0, thumbIdx: sender.thumbIdx ?? 0)
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
                self.reloadPofolList()
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
                self.reloadPofolList()
            default:
                return
            }
        }
    }

    /*댓글버튼 눌렀을 때*/
    @objc func commentBtnTapped(sender: UIButton){
        guard let commentTableVC = self.storyboard?.instantiateViewController(withIdentifier: "PorfolCommentViewController") as? PorfolCommentViewController else {return}
        commentTableVC.pofolIdx = sender.tag
        self.navigationController?.pushViewController(commentTableVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 520
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
}
