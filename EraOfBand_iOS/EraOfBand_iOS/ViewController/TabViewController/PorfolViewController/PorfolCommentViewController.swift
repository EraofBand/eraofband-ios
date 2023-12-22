//
//  PorfolCommentViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/16.
//

import UIKit
import Kingfisher
import Alamofire

class PorfolCommentViewController: UIViewController{
    
    @IBOutlet weak var textFieldView: UIView!
    var textViewYValue = CGFloat(0)
    var keyHeight: CGFloat?
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var enterCommentBtn: UIButton!
    
    var pofolIdx: Int?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard

    @IBOutlet weak var tableView: UITableView!
    var commentList: [CommentResult] = [CommentResult(content: "테스트1", nickName: "잼민", pofolCommentIdx: 0, pofolIdx: 0, profileImgUrl: "", updatedAt: "2시간 전", userIdx: 0)]
    
    
    @IBAction func enterBtnTapped(_ sender: Any) {
        view.endEditing(true)
        
        let header : HTTPHeaders = [
            "x-access-token": defaults.string(forKey: "jwt")!,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/pofols/comment/" + String(pofolIdx!),
                   method: .post,
                   parameters: [
                    "content": commentTextField.text ?? "",
                    "userIdx": defaults.integer(forKey: "userIdx")
                   ],
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ [self] response in
            print(response)
            
            self.commentTextField.text = ""
             
            print("appear 테스트")
            self.getCommentList()
            print(self.commentList)
            self.tableView.reloadData()
        }
        
        
    }
    
    @IBAction func commentTextFieldChanged(_ sender: Any) {
        if(commentTextField.text == ""){
            enterCommentBtn.isEnabled = false
        }else{
            enterCommentBtn.isEnabled = true
        }
        
    }

    func getCommentList(){
        let header : HTTPHeaders = [
            "x-access-token": defaults.string(forKey: "jwt")!,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/pofols/info/comment" + "?pofolIdx=" + String(pofolIdx!),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch response.result{
            case.success(let obj):
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj,
                                           options: .prettyPrinted)
                    let getData = try JSONDecoder().decode(CommentData.self, from: dataJSON)
                    print(getData)
                    self.commentList = getData.result
                    print(self.commentList)
                    
                    self.tableView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            default:
                return
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLayout(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 41))
        
        self.title = "댓글"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        enterCommentBtn.isEnabled = false
        
        commentTextField.borderStyle = .none
        commentTextField.layer.cornerRadius = 20
        
        commentTextField.leftView = paddingView
        commentTextField.rightView = paddingView
        commentTextField.leftViewMode = .always
        commentTextField.rightViewMode = .always
        commentTextField.layer.backgroundColor = UIColor.white.cgColor
        
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            let statusBarManager = window?.windowScene?.statusBarManager
            
            let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBarView.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
            
            window?.addSubview(statusBarView)
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
        }
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        
        setKeyBoardObserver()
        getCommentList()
    
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }
}

extension PorfolCommentViewController: UITableViewDataSource, UITableViewDelegate{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        
        cell.profileImgView.layer.cornerRadius = 35/2
        
        
        cell.nicknameLabel.text = commentList[indexPath.row].nickName
        cell.contentLabel.text = commentList[indexPath.row].content
        cell.dateLabel.text = commentList[indexPath.row].updatedAt
        
        let pofolImgUrl = URL(string: commentList[indexPath.row].profileImgUrl)
        cell.profileImgView.kf.setImage(with: pofolImgUrl)
        
        cell.selectionStyle = .none
        
        cell.profileBtn.tag = commentList[indexPath.row].userIdx
        cell.profileBtn.addTarget(self, action: #selector(profileBtnTapped(sender:)), for: .touchUpInside)
        
        /*댓글 메뉴 처리*/
        cell.menuBtn.tag = commentList[indexPath.row].pofolCommentIdx
        if(defaults.integer(forKey: "userIdx") == commentList[indexPath.row].userIdx){
            cell.menuBtn.addTarget(self, action: #selector(myMenuBtnTapped(sender:)), for: .touchUpInside)
        } else {
            cell.menuBtn.addTarget(self, action: #selector(otherMenuBtnTapped(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    func deleteComment(commentIdx: Int){
        let header : HTTPHeaders = [
            "x-access-token": defaults.string(forKey: "jwt")!,
            "Content-Type": "application/json"]
        
        AF.request("https://eraofband.shop/pofols/comment/status/" + String(commentIdx),
                   method: .patch,
                   parameters: [
                    "userIdx": defaults.integer(forKey: "userIdx")
                   ],
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            switch(response.result){
            case.success :
                self.getCommentList()
            default:
                return
            }
            
        }
    }
    
    /*내 댓글 메뉴 클릭시*/
    @objc func myMenuBtnTapped(sender: UIButton){
        let optionMenu = UIAlertController(title: nil, message: "댓글", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive, handler: {
                    (alert: UIAlertAction!) -> Void in
            self.deleteComment(commentIdx: sender.tag)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    /*다른 유저 댓글 메뉴 클릭시*/
    @objc func otherMenuBtnTapped(sender: UIButton){
        let optionMenu = UIAlertController(title: nil, message: "댓글", preferredStyle: .actionSheet)
        let declareAction = UIAlertAction(title: "신고하기", style: .destructive) {_ in
            let declareVC = self.storyboard?.instantiateViewController(withIdentifier: "DeclartionAlert") as! DeclarationAlertViewController
            
            declareVC.reportLocation = 2
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
    
    /*다른 유저 프로필로 넘어가기*/
    @objc func profileBtnTapped(sender: UIButton){
        if(sender.tag == defaults.integer(forKey: "userIdx")){
            guard let myPageVC = self.storyboard?.instantiateViewController(withIdentifier: "MypageTabViewController") as? MypageTabViewController else {return}
            
            myPageVC.viewMode = 1
            self.navigationController?.pushViewController(myPageVC, animated: true)
            
        }else{
            
            guard let otherUserVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserViewController") as? OtherUserViewController else {return}
            
            GetOtherUserDataService.getOtherUserInfo(sender.tag){ [self]
                (isSuccess, response) in
                if isSuccess{
                    otherUserVC.userData = response.result
                    otherUserVC.userIdx = sender.tag
                    self.navigationController?.pushViewController(otherUserVC, animated: true)
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
}

extension PorfolCommentViewController{
    
    func setKeyBoardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
                
            }
        }
    }
    
}
