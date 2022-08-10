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
    
    var chatListData: [messageListInfo] = []
    var lastChatData: [Int : chatInfo] = [:]
    
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
    
    /* 서버에서 채팅방 정보 리스트 가져오는 함수 */
    func getMessageList(completion: @escaping () -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
                print("message: \(messageInfoData)")
                self.chatListData = messageInfoData.result
                completion()
                
            case .failure(let err):
                print(err)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMessageList { [self] in
            
            for listData in chatListData { // 채팅방 정보로 반복문 실행
                let chatIdx = listData.chatRoomIdx
                getChatInfo(String(chatIdx)) { chatList in
                    self.lastChatData[chatIdx] = chatList // 채팅방 번호와 채팅방 내 대화 정보를 dictionary형태로 저장
                }
            }
            
            messageListTableView.delegate = self
            messageListTableView.dataSource = self
            messageListTableView.register(UINib(nibName: "MessageTableHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MessageTableHeaderView") // 검색창을 tableView의 headerView로 지정
            
        }

    }
    

}

extension MessageTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListTableViewCell", for: indexPath) as! MessageListTableViewCell
        
        let chatIdx = chatListData[indexPath.item].chatRoomIdx
        
        if let url = URL(string: chatListData[indexPath.item].profileImgUrl) {
            cell.userImageView.load(url: url)
        } else {
            cell.userImageView.image = UIImage(named: "default_image")
        }
        
        cell.nickNameLabel.text = chatListData[indexPath.item].nickName
        cell.RecentMessageLabel.text = lastChatData[chatIdx]?.message // 채팅방 Idx를 key로 가진 value값의 message값을 cell 라벨의 text값으로 지정
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MessageTableHeaderView") as! MessageTableHeaderView
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
