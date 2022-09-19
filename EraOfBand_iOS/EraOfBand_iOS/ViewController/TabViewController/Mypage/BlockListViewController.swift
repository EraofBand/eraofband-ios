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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getBlockList() { [self] in
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
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}
