//
//  BlockListViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/09/18.
//

import UIKit
import Alamofire

class BlockListViewController: UIViewController {

    @IBOutlet weak var blockListTableView: UITableView!
    
    var blockList: [blockListInfo] = []
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationBar() {
        
        self.navigationItem.title = "차단리스트"
        self.navigationItem.titleView?.tintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()

        getBlockList() { [self] in
            blockListTableView.separatorStyle = .none
            blockListTableView.delegate = self
            blockListTableView.dataSource = self
        }
        
    }
    

}

// MARK: API 통신
extension BlockListViewController {
    // 차단 리스트 API
    func getBlockList(completion: @escaping () -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let url = appDelegate.baseUrl + "/users/info/block"
        let header: HTTPHeaders = ["Content-Type": "application/json",
                                   "x-access-token": appDelegate.jwt]
        
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: header
        ).responseDecodable(of: BlockListData.self){ response in
            switch response.result{
            case .success(let blockListData):
                print(blockListData.result)
                self.blockList = blockListData.result
                completion()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func doBlock(_ userIdx: Int, completion: @escaping () -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/block/" + String(userIdx),
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON { response in
            switch response.result{
            case .success:
                print("차단 성공")
                completion()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func doUnBlock(_ userIdx: Int, completion: @escaping () -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/unblock/" + String(userIdx),
                   method: .delete,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON { response in
            switch response.result{
            case .success:
                print("차단 해제 성공")
                completion()
            case .failure(let err):
                print(err)
            }
        }
    }
}

// MARK: tableView 세팅
extension BlockListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockTableViewCell", for: indexPath) as! BlockTableViewCell
        
        if let url = URL(string: blockList[indexPath.item].profileImgUrl) {
            cell.userImageView.load(url: url)
        } else {
            cell.userImageView.image = UIImage(named: "default_image")
        }
        
        cell.nickNameLabel.text = blockList[indexPath.item].nickName
        cell.nickName = blockList[indexPath.item].nickName
        
        cell.blockButton.tag = indexPath.row
        if blockList[indexPath.item].blockChecked == 1 {
            cell.blockButton.setTitle("차단해제", for: .normal)
            cell.blockButton.backgroundColor = UIColor(named: "unfollow_btn_color")
            cell.blockButton.addTarget(self, action: #selector(unBlockBtnTapped), for: .touchUpInside)
        } else {
            cell.blockButton.setTitle("차단", for: .normal)
            cell.blockButton.backgroundColor = UIColor(named: "on_icon_color")
            cell.blockButton.addTarget(self, action: #selector(blockBtnTapped), for: .touchUpInside)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

// MARK: objc 함수
extension BlockListViewController {
    
    @objc func blockBtnTapped(_ sender: UIButton) {
        
        let blocked = blockList[sender.tag]
        
        //blockList[sender.tag].blockChecked = 1
        doBlock(blocked.userIdx) { [self] in
            blockList[sender.tag].blockChecked = 1
            blockListTableView.reloadData()
        }
        
    }
    
    @objc func unBlockBtnTapped(_ sender: UIButton) {
        
        let blocked = blockList[sender.tag]
        
        //blockList[sender.tag].blockChecked = 0
        doUnBlock(blocked.userIdx) { [self] in
            blockList[sender.tag].blockChecked = 0
            blockListTableView.reloadData()
        }
    }
}
