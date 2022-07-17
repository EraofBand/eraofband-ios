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

    @IBOutlet weak var tableView: UITableView!
    var commentList: [CommentResult] = [CommentResult(content: "테스트1", nickName: "잼민", pofolCommentIdx: 0, pofolIdx: 0, profileImgUrl: "", updatedAt: "2시간 전", userIdx: 0)]
    
    
    @IBAction func enterBtnTapped(_ sender: Any) {
        view.endEditing(true)
        
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/pofol/" + String(pofolIdx!) + "/comment",
                   method: .post,
                   parameters: [
                    "content": commentTextField.text ?? "",
                    "userIdx": appDelegate.userIdx!
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
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/pofol/comment/" + "?postIdx=" + String(pofolIdx!),
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
        
        cell.nicknameLabel.text = commentList[indexPath.row].nickName
        cell.contentLabel.text = commentList[indexPath.row].content
        cell.dateLabel.text = commentList[indexPath.row].updatedAt
        
        let pofolImgUrl = URL(string: "https://mblogthumb-phinf.pstatic.net/20130602_46/unrealaisle_1370152094130HHCmf_JPEG/gongsil_dooli_640.jpg?type=w2")
        cell.profileImgView.kf.setImage(with: pofolImgUrl)
        
        cell.selectionStyle = .none
        
        return cell
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
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    /*텍스트필드만 올라오게 하기.. 일단 보류
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if textViewYValue == 0{
                textViewYValue = self.textFieldView.frame.origin.y
            }
            
            if self.textFieldView.frame.origin.y == textViewYValue {
                textViewYValue = self.textFieldView.frame.origin.y
                self.textFieldView.frame.origin.y -= keyboardSize.height - (view.window?.windowScene?.keyWindow?.safeAreaInsets.bottom)!
                
                
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        
        if self.textFieldView.frame.origin.y != textViewYValue {
            self.textFieldView.frame.origin.y = textViewYValue
        }
        
    }
     */
}
