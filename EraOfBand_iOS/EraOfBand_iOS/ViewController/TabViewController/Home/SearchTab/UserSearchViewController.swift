//
//  UserSearchViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/04.
//

import UIKit

class UserSearchViewController: UIViewController {

    @IBOutlet weak var userResultTableView: UITableView!
    
    var userResult: [userResultInfo] = [] {
        didSet {
            //userResultTableView.reloadData()
        }
    }
    
    let session = ["보컬", "기타", "베이스", "키보드", "드럼"]
    
    func reloadTable(_ userResult: [userResultInfo]) {
        
        self.userResult = userResult
        
        print("아래 탭 바:\(self.userResult)")
        
        //userResultTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userResultTableView.delegate = self
        userResultTableView.dataSource = self
    
    }
    

}

extension UserSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchTableViewCell") as! UserSearchTableViewCell
        
        if let url = URL(string: userResult[indexPath.item].profileImgUrl) {
            cell.userImageView.load(url: url)
            cell.userImageView.contentMode = .scaleAspectFill
        } else {
            cell.userImageView.image = UIImage(named: "default_image")
        }
        
        cell.nickNameLabel.text = userResult[indexPath.item].nickName
        
        let sessionNum = userResult[indexPath.item].userSession
        cell.sessionLabel.text = session[sessionNum]
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let otherVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUser") as! OtherUserViewController
        
        otherVC.userIdx = userResult[indexPath.item].userIdx
        self.navigationController?.pushViewController(otherVC, animated: true)
        
    }
    
    
}