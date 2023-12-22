//
//  ChatViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/08.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Alamofire
import Firebase

struct Sender: SenderType{
    var senderId: String
    var displayName: String
}

struct Message: MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var readUser: Bool
}

struct ChatroomInData: Codable{
    var code: Int
    var isSuccess: Bool
    var message: String
    var result: ChatroomInResult
}

struct ChatroomInResult: Codable{
    var lastChatIdx: Int
}

class ChatViewController: MessagesViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    
    var chatRoomIdx: String = "none"
    var otherUserInfo: GetOtherUser?
    var chatList: [chatInfo]?
    var chatUserInfo: userIdxInfo?
    var myOutIdx: Int = -1
    var lastChatIdx: Int = -1
    
    var currentUser = Sender(senderId: "current", displayName: "Me")
    var otherUser: SenderType = Sender(senderId: "other", displayName: "Other")
    
    var messages = [Message]()
    let chatReference = Database.database().reference()
    
    /*해당 유저와 채팅 내역이 없을 때 채팅방 생성 처리*/
    func makeChat(completion: @escaping () -> Void){
        let header : HTTPHeaders = ["x-access-token": defaults.string(forKey: "jwt")!,
                                    "Content-Type": "application/json"]
        let url = appDelegate.baseUrl + "/chat"
        let uuidStr = UUID().uuidString
        chatRoomIdx = uuidStr
        AF.request(url,
                   method: .post,
                   parameters: [
                    "chatRoomIdx": uuidStr,
                    "firstUserIdx": defaults.integer(forKey: "userIdx"),
                    "secondUserIdx": otherUserInfo?.userIdx
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
            
            //print(chatData)
            // 채팅방 정보 JSON형식으로 parsing
            let data = try! JSONSerialization.data(withJSONObject: chatData)
            //print(data)
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
    
    func getChatUserInfo(completion: @escaping (()->Void)){
        //print("함수 실행")
        chatReference.child("chat").child(chatRoomIdx).child("users").observe(.value) { snapshot in
            //print("테스트:")
            guard let chatUserData = snapshot.value else { return }
            print(chatUserData)
            // 채팅방 정보 JSON형식으로 parsing
            let data = try! JSONSerialization.data(withJSONObject: chatUserData)
            print(data)
            do {
                // 채팅방 정보 Decoding
                //print(data)
                let decoder = JSONDecoder()
                self.chatUserInfo = try decoder.decode(userIdxInfo.self, from: data)
                completion()
            } catch let error {
                print("\(error.localizedDescription)")
            }
            
        }
    }
    
    /*우측 상단 메뉴 버튼 클릭시*/
    @objc func menuBtnTapped(){
        let optionMenu = UIAlertController(title: nil, message: "채팅방", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "채팅방 나가기", style: .destructive, handler: {
                    (alert: UIAlertAction!) -> Void in
            self.deleteChat()
                })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
              })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    /*채팅방 나가기*/
    func deleteChat(){
        let header : HTTPHeaders = [
            "x-access-token": defaults.string(forKey: "jwt")!,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/chat/status/" + self.chatRoomIdx,
                   method: .patch,
                   parameters: [
                    "lastChatIdx": self.chatList!.count - 1
                   ],
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ [self] response in
            switch(response.result){
            case.success :
                self.navigationController?.popViewController(animated: true)
            
            default:
                return
            }
            
        }
    }
    
    /*채팅방 들어가기 - 마지막 나가기 인덱스 가져오기*/
    func chatroomIn(){
        let header : HTTPHeaders = [
            "x-access-token": defaults.string(forKey: "jwt")!,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/chat/chatroom-in",
                   method: .patch,
                   parameters: [
                    "chatRoomIdx": self.chatRoomIdx
                   ],
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: ChatroomInData.self){ response in
            switch(response.result){
            case.success(let chatroomInData) :
                print("테스트 : ", chatroomInData.result)
                self.lastChatIdx = chatroomInData.result.lastChatIdx
                self.loadChat()
            default:
                print(response)
                return
            }
            
        }
    }
    
    @objc func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLayout(){
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
        view.addSubview(statusBarView)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let leftBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backBtnTapped))
        self.navigationItem.leftBarButtonItem = leftBtn
        
        let rightBtn = UIBarButtonItem(image: UIImage(named: "ic_more"), style: .plain, target: self, action: #selector(menuBtnTapped))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.setMessageIncomingAvatarSize(.init(width: 40, height: 40))
            layout.setMessageIncomingMessagePadding(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
            layout.setMessageIncomingAvatarPosition(AvatarPosition(vertical: .messageLabelTop))
            
            layout.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 10, right: 0))
            layout.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 35))
        }
        
        messagesCollectionView.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
        messageInputBar.inputTextView.placeholder = "메세지를 입력해주세요."
        messageInputBar.sendButton.title = "보내기"
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 10)
        
        messageInputBar.contentView.backgroundColor = .white
        messageInputBar.contentView.layer.cornerRadius = 20
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.font = UIFont(name:"Pretendard-Medium",size:12)!
        messageInputBar.inputTextView.textColor = .black
        
        
        messageInputBar.padding.top = 5
        messageInputBar.padding.bottom = 5
        // or MiddleContentView padding
        messageInputBar.middleContentViewPadding.top = 5
        messageInputBar.middleContentViewPadding.bottom = 5
        
        messageInputBar.inputTextView.textContainerInset = .init(top: 7, left: 20, bottom: 3, right: 20)
        messageInputBar.backgroundView.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)

        self.navigationController?.navigationBar.height = 100
        
        self.title = self.otherUserInfo?.nickName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otherUser = Sender(senderId: "other", displayName: self.otherUserInfo?.nickName ?? "")
        
        setLayout()
        
        /*
        if(chatRoomIdx != "none"){
            /*내가 나간 시점의 인덱스 값 구하기*/
            getChatUserInfo { [self] in
                if(chatUserInfo!.firstUserIdx == self.appDelegate.userIdx){
                    self.myOutIdx = chatUserInfo!.firstOutIdx
                }else{
                    self.myOutIdx = chatUserInfo!.secondOutIdx
                }
            }
            /*채팅 내역 불러오기*/
            loadChat()
        }else{
            
        }*/
        
        chatroomIn()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        messageInputBar.delegate = self
        
        self.view.layer.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1).cgColor
        
    }

    func loadChat(){
        getChatInfo(chatRoomIdx){ [self]result in
            self.chatList = result
            //print(self.chatList)
            messages = []
            for i in (lastChatIdx + 1)..<self.chatList!.count{
                if(self.chatList![i].userIdx == self.defaults.integer(forKey: "userIdx")){
                    messages.append(Message(sender: currentUser,
                                            messageId: String(i),
                                            sentDate: Date(milliseconds: Int64(self.chatList![i].timeStamp)),
                                            kind: .text(self.chatList![i].message),
                                            readUser: chatList![i].readUser
                                           ))
                }else{
                    messages.append(Message(sender: otherUser,
                                            messageId: String(i),
                                            sentDate: Date(milliseconds: Int64(self.chatList![i].timeStamp)),
                                            kind: .text(self.chatList![i].message),
                                            readUser: chatList![i].readUser
                                           ))
                    
                    self.chatReference.child("chat").child("\(self.chatRoomIdx)").child("comments").child(String(i)).child("readUser").setValue(true)
                }
            }
            
            self.messagesCollectionView.reloadData()
            
            //self.messagesCollectionView.scrollToLastItem(animated: true)
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }

}

/*배경 탭 시 키보드 숨기기*/
extension ChatViewController: MessageCellDelegate {
    @objc(didTapBackgroundIn:) func didTapBackground(in cell: MessageCollectionViewCell) {
        self.messageInputBar.inputTextView.resignFirstResponder()
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        //채팅 보내기
        if(chatRoomIdx == "none"){
            //채팅방이 없을 때
            makeChat(completion: {
                self.chatReference.child("chat").child("\(self.chatRoomIdx)").child("users").child("firstUserIdx").setValue(self.defaults.integer(forKey: "userIdx"))
                self.chatReference.child("chat").child("\(self.chatRoomIdx)").child("users").child("secondUserIdx").setValue(self.otherUserInfo?.userIdx)
                self.sendMessage(text: text, chatIdx: "0")
                self.loadChat()
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
        self.chatReference.child("chat").child("\(self.chatRoomIdx)").child("comments").child(chatIdx).child("userIdx").setValue(self.defaults.integer(forKey: "userIdx"))
        
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
        return LabelAlignment(textAlignment: .left, textInsets: .init(top: 0, left: 50, bottom: 10, right: 0))
    }
    
    // 말풍선의 꼬리 모양 방향
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let cornerDirection: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .topRight : .topLeft
        return .bubbleTail(cornerDirection, .pointedEdge)
    }
    
    // 내 프로필 사진 숨기기
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if !isFromCurrentSender(message: message){
            if(self.otherUserInfo?.profileImgUrl.prefix(13) == "https://eraof"){
                avatarView.load(url: URL(string: self.otherUserInfo?.profileImgUrl ?? "")!)
            }
        }
    }
    
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        accessoryView.subviews.forEach{
            $0.removeFromSuperview()
        }
        
        accessoryView.height = 15
        accessoryView.width = 100
        let accessoryLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 15))
        accessoryLabel.text = message.sentDate.toString().substring(from: 11, to: 15)
        accessoryLabel.font = UIFont(name: "Pretendard-Medium", size: 10)
        accessoryLabel.textColor = UIColor(red: 0.576, green: 0.576, blue: 0.576, alpha: 1)
        
        let readIndicator = UIView(frame: CGRect(x: -10, y: 5, width: 6, height: 6))
        readIndicator.layer.backgroundColor = UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1).cgColor
        readIndicator.layer.cornerRadius = 3
        
        if isFromCurrentSender(message: message){
            accessoryView.contentMode = .left
            accessoryView.addSubview(accessoryLabel)

            if(messages[indexPath.section].readUser == false){
                accessoryView.addSubview(readIndicator)
            }
            
        }else{
            accessoryView.contentMode = .right
            accessoryView.addSubview(accessoryLabel)
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
