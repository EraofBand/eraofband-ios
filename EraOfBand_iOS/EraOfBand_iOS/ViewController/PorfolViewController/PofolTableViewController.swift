//
//  PofolTableViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/14.
//

import UIKit
import Alamofire
import Kingfisher

class PofolTableViewController: UIViewController{
    
    var pofolList: [PofolResult] = [PofolResult(commentCount: 0, content: "", likeOrNot: "", nickName: "", pofolIdx: 0, pofolLikeCount: 0, profileImgUrl: "", title: "", updatedAt: "", userIdx: 0, videoUrl: "")]
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*좋아요 업데이트를 위한 포폴리스트 리로드 함수*/
    func reloadPofolList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        //print(appDelegate.baseUrl + "/pofol/my/" + "?userIdx=" + String(appDelegate.userIdx!))
        
        AF.request(appDelegate.baseUrl + "/pofol/my/" + "?userIdx=" + String(appDelegate.userIdx!),
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
        
        AF.request(appDelegate.baseUrl + "/pofol/my/" + "?userIdx=" + String(appDelegate.userIdx!),
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        
    }
}

extension PofolTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pofolList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPofolTableViewCell", for: indexPath) as! MyPofolTableViewCell
        
        cell.nameLabel.text = pofolList[indexPath.row].nickName
        cell.titleLabel.text = pofolList[indexPath.row].title
        cell.dateLabel.text = pofolList[indexPath.row].updatedAt
        cell.descriptionLabel.text = pofolList[indexPath.row].content
        
        cell.likeLabel.text = String(pofolList[indexPath.row].pofolLikeCount!)
        cell.commentLabel.text = String(pofolList[indexPath.row].commentCount!)
        
        let profileImgUrl = URL(string: "https://i.discogs.com/djxaXzopa-ITbJTjpeTBgXlR81XYu9egAYkhkZUvYbM/rs:fit/g:sm/q:90/h:674/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9BLTQ4NTQt/MTUxNTUxODIzNS02/ODI4LmpwZWc.jpeg")
        cell.profileImgView.kf.setImage(with: profileImgUrl)
        cell.profileImgView.layer.cornerRadius = 35/2
        
        let pofolImgUrl = URL(string: "https://mblogthumb-phinf.pstatic.net/20130602_46/unrealaisle_1370152094130HHCmf_JPEG/gongsil_dooli_640.jpg?type=w2")
        cell.pofolImgView.kf.setImage(with: pofolImgUrl)
        
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
        
        
        
        return cell
    }
    
    /*좋아요 취소*/
    @objc func deleteLike(sender: UIButton){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/pofol/" + String(sender.tag) + "/unlikes",
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
        
        AF.request(appDelegate.baseUrl + "/pofol/" + String(sender.tag) + "/likes",
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
}
