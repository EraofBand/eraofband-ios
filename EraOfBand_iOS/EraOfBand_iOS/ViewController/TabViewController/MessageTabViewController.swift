//
//  MessageTabView.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/06.
//

import UIKit
import Alamofire
import Firebase

class MessageTabViewController: UIViewController {
    
    @IBOutlet weak var messageListTableView: UITableView!

    let chatReference = Database.database().reference()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var chatListData: [messageListInfo] = [] // 서버에서 가져온 모든 채팅방 정보 저장 변수
    var searchListData: [messageListInfo] = [] // 검색창에 검색해 나온 채팅방 정보만 저장될 변수
    var lastChatData: [String : chatInfo] = [:]
    //var userIdxData: [userIdxInfo] = []
    
    var chatRoomIdx: Int?
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    /*검색창 밖 탭 시 키보드 비활성화*/
    @IBAction func backgroundTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    /* 네비게이션 바 커스텀 */
    func setNavigationBar() {
        self.navigationController?.navigationBar.clipsToBounds = true //네비게이션 바 밑 보더 지우기
        
        var leftBarButtons: [UIBarButtonItem] = []
        
        let mypageLabel = UILabel()
        mypageLabel.text = "채팅"
        mypageLabel.font = UIFont(name: "Pretendard-Medium", size: 25)
        mypageLabel.textColor = .white
        
        let mypageBarButton = UIBarButtonItem(customView: mypageLabel)
        
        leftBarButtons.append(mypageBarButton)
        
        self.navigationItem.leftBarButtonItems = leftBarButtons
        
    }
    
    /* firebase에서 채팅 정보 가져오는 함수 */
    func getChatInfo(_ chatIdx: String, completion: @escaping (chatInfo) -> Void) {
        
        chatReference.child("chat").child(chatIdx).child("comments").observe(.value) { snapshot in
            guard let chatData = snapshot.value as? [Any] else { return }
            
            // 채팅방 정보 JSON형식으로 parsing
            let data = try! JSONSerialization.data(withJSONObject: chatData.last, options: [])
            do {
                // 채팅방 정보 Decoding
                let decoder = JSONDecoder()
                let chatList = try decoder.decode(chatInfo.self, from: data)
                print("chatList : \(chatList)")
                completion(chatList) // 채팅방에서 마지막으로 말한 comment 정보 반환
            } catch let error {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    /*
    /* 채팅방 유저 idx값 받아오는 함수 */
    func getUserIdxInfo(_ chatIdx: String, completion: @escaping (userIdxInfo) -> Void) {
        
        chatReference.child("chat").child(chatIdx).child("users").observe(.value) { snapshot in
            guard let userData = snapshot.value else { return print("머노") }
            print("userData : \(userData)")
            // 채팅방 정보 JSON형식으로 parsing
            let data = try! JSONSerialization.data(withJSONObject: userData, options: [])
            do {
                // 채팅방 정보 Decoding
                let decoder = JSONDecoder()
                let userIdx = try decoder.decode(userIdxInfo.self, from: data)
                print("userIdx : \(userIdx)")
                completion(userIdx) // 채팅방 usersIdx 반환
            } catch let error {
                print("\(error.localizedDescription)")
            }
        }
        
    }*/
    
    /* 서버에서 채팅방 정보 리스트 가져오는 함수 */
    func getMessageList(completion: @escaping () -> Void) {
        
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/chat/chat-room"
        
        
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: MessageListData.self){ response in
            switch response.result{
            case .success(let messageInfoData):
                
                self.chatListData = []
                self.searchListData = []
                
                print("message: \(messageInfoData)")
                self.chatListData = messageInfoData.result
                completion()
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /* 검색 textField에 값이 변경될 때 마다 실행되는 함수 */
    @objc func didChanged(_ textField: UITextField) {
        
        if textField.text == "" {
            searchListData = chatListData // 빈 칸일 경우 모든 채팅방 리스트 return
        } else {
            searchListData = [] // 반복문 전 배열 초기화
            for name in chatListData {
                if name.nickName.contains(textField.text!) {
                    searchListData.append(name) // 검색어에 해당되는 채팅방 정보를 searchListData 배열에 append
                }
            }
        }
        messageListTableView.reloadData() // searchListData 세팅 끝낸 후 테이블뷰 reload
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageListTableView.separatorStyle = .none
        
        setNavigationBar()
        
        messageListTableView.delegate = self
        messageListTableView.dataSource = self
        messageListTableView.register(UINib(nibName: "MessageTableHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MessageTableHeaderView") // 검색창을 tableView의 headerView로 지정
        
        messageListTableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        
        tapGesture.cancelsTouchesInView = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getMessageList { [self] in
            
            searchListData = []
            for listData in chatListData { // 채팅방 정보로 반복문 실행
                
                let chatIdx = listData.chatRoomIdx
                
                getChatInfo(chatIdx) { [self] chatList in
                    lastChatData[chatIdx] = chatList // 채팅방 번호와 채팅방 내 대화 정보를 dictionary형태로 저장
                    searchListData.append(listData)
                    messageListTableView.reloadData() // 정보 가져온 후 tableView reload
                    
                    /*
                    getUserIdxInfo(chatIdx) { [self] userIdx in
                        userIdxData.append(userIdx) // 채팅방 유저 idx값 받아와 userIdxData배열에 append
                    }*/
                }
            }
            //print("AfterFor userIdxData: \(userIdxData)")
        }
    }
}

extension MessageTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListTableViewCell", for: indexPath) as! MessageListTableViewCell
        
        let chatIdx = searchListData[indexPath.item].chatRoomIdx
        
        if let url = URL(string: searchListData[indexPath.item].profileImgUrl) {
            cell.userImageView.load(url: url)
        } else {
            cell.userImageView.image = UIImage(named: "default_image")
        }
        
        cell.nickNameLabel.text = searchListData[indexPath.item].nickName
        cell.RecentMessageLabel.text = lastChatData[chatIdx]?.message // 채팅방 Idx를 key로 가진 value값의 message값을 cell 라벨의 text값으로 지정
        
        if let checkBool = lastChatData[chatIdx]?.readUser {
            if (checkBool) || (lastChatData[chatIdx]?.userIdx == appDelegate.userIdx) {
                cell.checkView.isHidden = true // 최근 message를 읽었을 경우 빨간점 isHidden
            } else {
                cell.checkView.isHidden = false // 최근 message를 읽지 않았을 경우 빨간점 보이게
            }
        }
        
        cell.calcDate(Int64(lastChatData[chatIdx]!.timeStamp)) // 마지막 메세지를 받고(보내고) 난 후 시간
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MessageTableHeaderView") as! MessageTableHeaderView
        
        header.searchTextField.addTarget(self, action: #selector(didChanged), for: .editingChanged)
        header.searchTextField.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatRoomIdx = searchListData[indexPath.item].chatRoomIdx
        //let userInfo = userIdxData[indexPath.item]
        var otherUserIdx: Int = 0
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        otherUserIdx = searchListData[indexPath.item].otherUserIdx
        
        
        GetOtherUserDataService.getOtherUserInfo(otherUserIdx) { (isSuccess, response) in // otherUser 정보 가져오기
            if isSuccess { // 해당 채팅방으로 이동
                print("성공..")
                let messageVC = ChatViewController()
                messageVC.chatRoomIdx = chatRoomIdx
                messageVC.otherUserInfo = response.result.getUser
                messageVC.hidesBottomBarWhenPushed = true // 채팅방에서 bottomBar 안보이게 설정
                self.navigationController?.pushViewController(messageVC, animated: true)
            }
        }
    }
}

extension MessageTabViewController: UITextFieldDelegate{
    //화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
}
