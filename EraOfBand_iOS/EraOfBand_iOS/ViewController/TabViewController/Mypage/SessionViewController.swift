//
//  SessionViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/17.
//

import UIKit
import Alamofire

class SessionViewController: UIViewController {

    @IBOutlet weak var sessionCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var sessionData: [String] = ["보컬", "기타", "베이스", "드럼", "키보드"]
    var session: Int = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sessionCollectionView.delegate = self
        sessionCollectionView.dataSource = self
        
        self.navigationItem.title = "세션 변경"

        saveButton.layer.cornerRadius = 13
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let params: Dictionary<String, Any?> = ["userIdx": appDelegate.userIdx,
                                                "userSession": session]
        
        let urlString = appDelegate.baseUrl + "/users/user-session"
        let header: HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                   "Content-Type": "application/json"]
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "PATCH"
        request.headers = header
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                self.appDelegate.userSession = self.session
                print("POST한 세션 번호: \(self.session)")
                print("POST 성공")
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SessionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sessionData.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionChangeCollectionViewCell", for: indexPath) as! SessionChangeCollectionViewCell
        
        cell.backgroundColor = .clear
        cell.sessionName = sessionData[indexPath.item]
        cell.sessionImageView.image = UIImage(named: "ic_session_off")
        
        if indexPath.item == session {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click index=\(indexPath.row)")
        
        session = indexPath.row
        
    }
    
}

extension SessionViewController: UICollectionViewDelegateFlowLayout {
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    // cell 사이즈( 옆 라인을 고려하여 설정 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 3
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 2
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        let size = CGSize(width: cellWidth, height: cellHeight)

        return size
    }
}
