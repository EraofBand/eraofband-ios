//
//  ChatViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/08.
//

import UIKit
import MessageKit

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
    
    var currentUser = Sender(senderId: "current", displayName: "Jaem")
    var otherUser: SenderType = Sender(senderId: "other", displayName: "Harry")
    
    var messages = [Message]()
    
    func setLayout(){
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.setMessageIncomingAvatarSize(.init(width: 40, height: 40))
        }
        
        messagesCollectionView.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        
        messages.append(Message(sender: currentUser,
                                messageId: "1",
                                sentDate: Date().addingTimeInterval(-86400),
                                kind: .text("Hello")))
        messages.append(Message(sender: otherUser,
                                messageId: "2",
                                sentDate: Date().addingTimeInterval(-70000),
                                kind: .text("Hi, how are you")))
        messages.append(Message(sender: currentUser,
                                messageId: "3",
                                sentDate: Date().addingTimeInterval(-66400),
                                kind: .text("fine")))

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        self.view.layer.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1).cgColor
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
        return isFromCurrentSender(message: message) ? nil : NSAttributedString(string: message.sender.displayName, attributes: [.foregroundColor: UIColor(.white)])
    }
    
    /*
    func messageTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment? {
        return LabelAlignment(textAlignment: .init(rawValue: 0), textInsets: .init(top: 50, left: 0, bottom: 0, right: 0))
    }*/
    
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
