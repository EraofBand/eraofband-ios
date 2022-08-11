//
//  ChatViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/08.
//

import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView
import Alamofire

struct Sender: SenderType{
    var senderId: String
    var displayName: String
}

struct Message: MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}



class ChatViewController: MessagesViewController{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var chatRoomIdx: String = "none"
    var otherUserIdx: Int?
    var chatList: [chatInfo]?
    
    var currentUser = Sender(senderId: "current", displayName: "Jaem")
    var otherUser: SenderType = Sender(senderId: "other", displayName: "Harry")
    
    var messages = [Message]()
    let chatReference = Database.database().reference()
    
    /*해당 유저와 채팅 내역이 없을 때 채팅방 생성 처리*/
    func makeChat(completion: @escaping () -> Void){
        let header : HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/chat"
        let uuidStr = UUID().uuidString
        chatRoomIdx = uuidStr
        AF.request(url,
                   method: .post,
                   parameters: [
                    "chatRoomIdx": uuidStr,
                    "firstUserIdx": appDelegate.userIdx!,
                    "secondUserIdx": otherUserIdx!
                   ],
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            
            switch response.result{
            case .success:
                completion()
                
            case .failure(let err):
                print(err)
            }
            
        }
    }
    
    /* firebase에서 채팅 정보 가져오는 함수 */
    func getChatInfo(_ chatIdx: String, completion: @escaping ([chatInfo]) -> Void) {
        
        chatReference.child("chat").child(chatIdx).child("comments").observe(.value) { snapshot in
            guard let chatData = snapshot.value as? [Any] else { return }
            
            print(chatData)
            // 채팅방 정보 JSON형식으로 parsing
            let data = try! JSONSerialization.data(withJSONObject: chatData)
            print(data)
            do {
                // 채팅방 정보 Decoding
                //print(data)
                let decoder = JSONDecoder()
                let chatList = try decoder.decode([chatInfo].self, from: data)
                //print("chatList : \(chatList)")
                completion(chatList) // 채팅방에서 마지막으로 말한 comment 정보 반환
            } catch let error {
                print("\(error.localizedDescription)")
            }
            
        }
        
    }
    
    @objc func menuBtnTapped(){
        print("test")
    }
    
    func setLayout(){
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        //self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_more"), style: .plain, target: self, action: #selector(menuBtnTapped))
        //self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "메뉴", style: .plain, target: self, action: #selector(menuBtnTapped))
        
        let rightBtn = UIBarButtonItem(image: UIImage(named: "ic_more"), style: .plain, target: self, action: #selector(menuBtnTapped))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.setMessageIncomingAvatarSize(.init(width: 40, height: 40))
        }
        
        messagesCollectionView.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
        messageInputBar.inputTextView.placeholder = "메세지를 입력해주세요."
        messageInputBar.sendButton.title = "보내기"

        messageInputBar.contentView.backgroundColor = .white
        messageInputBar.contentView.layer.cornerRadius = 15
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.font = UIFont(name:"Pretendard-Medium",size:12)!
        
        messageInputBar.inputTextView.textContainerInset.bottom = 10
        messageInputBar.inputTextView.textContainerInset.top = 10
         
        messageInputBar.inputTextView.textContainerInset = .init(top: 10, left: 20, bottom: 0, right: 20)
        messageInputBar.backgroundView.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)

        self.navigationController?.navigationBar.height = 100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otherUser = Sender(senderId: "other", displayName: self.title ?? "")
        
        setLayout()
        
        if(chatRoomIdx != "none"){
            getChatInfo(chatRoomIdx){ [self]result in
                self.chatList = result
                //print(self.chatList)
                
                
                
                for i in 0..<self.chatList!.count{
                    if(self.chatList![i].userIdx == self.appDelegate.userIdx){
                        messages.append(Message(sender: currentUser,
                                                messageId: String(i),
                                                sentDate: Date(milliseconds: Int64(self.chatList![i].timeStamp)),
                                                kind: .text(self.chatList![i].message)))
                    }else{
                        messages.append(Message(sender: otherUser,
                                                messageId: String(i),
                                                sentDate: Date(milliseconds: Int64(self.chatList![i].timeStamp)),
                                                kind: .text(self.chatList![i].message)))
                    }
                }
                
                self.messagesCollectionView.reloadData()
            }
        }else{
            
        }
        

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        
        self.view.layer.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1).cgColor
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //messageInputBar.inputTextView.becomeFirstResponder() //채팅방 들어가자마자 키보드 올라오게
    }*/

}

extension ChatViewController: InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("test")
        //채팅 보내기
        if(chatRoomIdx == "none"){
            //채팅방이 없을 때
            makeChat(completion: {
                self.sendMessage(text: text, chatIdx: "0")
            })
        }else{
            self.sendMessage(text: text, chatIdx: String(self.chatList!.count))
        }
    }
    
    func sendMessage(text: String, chatIdx: String){
        self.chatReference.child("chat").child("\(self.chatRoomIdx)").child("comments").child(chatIdx).child("message").setValue(text)
        self.chatReference.child("chat").child("\(self.chatRoomIdx)").child("comments").child(chatIdx).child("readUser").setValue(false)
        
        let currentTimeStamp = Date().millisecondsSince1970
        self.chatReference.child("chat").child("\(self.chatRoomIdx)").child("comments").child(chatIdx).child("timeStamp").setValue(currentTimeStamp)
        self.chatReference.child("chat").child("\(self.chatRoomIdx)").child("comments").child(chatIdx).child("userIdx").setValue(self.appDelegate.userIdx)
        self.chatReference.child("chat").child("\(self.chatRoomIdx)").child("users").child("firstUserIdx").setValue(self.appDelegate.userIdx)
        self.chatReference.child("chat").child("\(self.chatRoomIdx)").child("users").child("secondUserIdx").setValue(self.otherUserIdx)
        
        messages = []
        
        self.messageInputBar.inputTextView.text = ""
        self.isEditing = false
    }
}

extension ChatViewController: MessagesDataSource{
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
}

extension ChatViewController: MessagesLayoutDelegate{
    
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: -30)
    }
        
    // 말풍선 위 이름 나오는 곳의 height
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 25
    }
    
}

extension ChatViewController: MessagesDisplayDelegate {
    
    // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) : UIColor(red: 0.125, green: 0.133, blue: 0.157, alpha: 1)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return isFromCurrentSender(message: message) ? nil : NSAttributedString(string: message.sender.displayName, attributes: [.foregroundColor: UIColor(.white),
                                                                                                                                 .font: UIFont(name:"Pretendard-Medium",size:16)!])
    }
    
    func messageTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment? {
        return LabelAlignment(textAlignment: .left, textInsets: .init(top: 0, left: 45, bottom: 0, right: 0))
    }
    
    // 말풍선의 꼬리 모양 방향
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let cornerDirection: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .topRight : .topLeft
        return .bubbleTail(cornerDirection, .pointedEdge)
    }
    
    // 내 프로필 사진 숨기기
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if isFromCurrentSender(message: message){
            avatarView.isHidden = true
        }
    }
}

extension Date{
    var millisecondsSince1970: Int64 {
            Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        }
        
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }

}
