//
//  SearchViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/04.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var currentSearch = "user"
    
    var userResult: [userResultInfo] = []
    var bandResult: [bandInfo] = []
    var lessonResult: [lessonInfo] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func dismissAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func didChanged(_ textField: UITextField) {
        
        getUserResult(textField.text!) { [self] userResultResponse in
            
            getBandResult(textField.text!) { [self] bandResultResponse in
                
                getLessonResult(textField.text!) { lessonResultResponse in
                    
                    NotificationCenter.default.post(name: .searchNotifName, object: nil, userInfo: ["user": userResultResponse, "band": bandResultResponse, "lesson": lessonResultResponse])
                }
            }
        }
        
    }
    
    func getUserResult(_ keyword: String, completion: @escaping ([userResultInfo]) -> Void) {
        
        var url = "\(appDelegate.baseUrl)/search/users/" + keyword
        url = url.encodeUrl()!
        
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header).responseDecodable(of: SearchUserData.self) { response in
            switch response.result{
            case .success(let userInfoData):
                print(userInfoData)
                self.userResult = userInfoData.result
                completion(userInfoData.result)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getBandResult(_ keyword: String, completion: @escaping ([bandInfo]) -> Void) {
        
        var url = "\(appDelegate.baseUrl)/search/bands/" + keyword
        url = url.encodeUrl()!
        
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header).responseDecodable(of: BandListData.self) { response in
            switch response.result{
            case .success(let bandInfoData):
                print(bandInfoData)
                self.bandResult = bandInfoData.result
                completion(bandInfoData.result)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getLessonResult(_ keyword: String, completion: @escaping ([lessonInfo]) -> Void) {
        
        var url = "\(appDelegate.baseUrl)/search/lessons/" + keyword
        url = url.encodeUrl()!
        
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header).responseDecodable(of: LessonListData.self) { response in
            switch response.result{
            case .success(let lessonInfoData):
                print(lessonInfoData)
                self.lessonResult = lessonInfoData.result
                completion(lessonInfoData.result)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.layer.cornerRadius = 10
        searchTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)])
        
        searchTextField.addTarget(self, action: #selector(didChanged), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //print(currentSearch)
        if segue.identifier == "searchEmbed"{
            let containerVC = segue.destination as!SearchTabManViewController
            
            containerVC.currentSearch = self.currentSearch
        }
        
    }

}

extension Notification.Name {
    static let searchNotifName = Notification.Name("DidReceiveResult")
    static let keyboardNotifName = Notification.Name("KeyboardNotification")
}
