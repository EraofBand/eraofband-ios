//
//  ModifyPostViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/10/01.
//

import UIKit
import Alamofire

class ModifyPostViewController: UIViewController {
    
    var boardInfo: boardInfoResult?
    
    @IBOutlet weak var choiceBoardBtn: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var postImgArr: [UIImage] = [UIImage()]
    var imgUrlArr: [[String: String]] = [["imgUrl": ""]]
    var nullImg = true
    let imgPicker = UIImagePickerController()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func BackBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func modifyBtnTapped(_ sender: Any) {
        
        let header: HTTPHeaders = ["x-access-token": self.appDelegate.jwt,
                                    "Content-Type": "application/json"]
        let contentUrl = appDelegate.baseUrl + "/board/board-info/" + String(boardInfo!.boardIdx)
        
        AF.request(contentUrl,
                   method: .patch,
                   parameters: [
                    "content": self.descriptionTextView.text ?? "",
                    "title": self.titleTextField.text ?? "",
                    "userIdx": self.appDelegate.userIdx!
                   ],
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON{ response in
            print("게시글 수정 결과")
            print(response)
        }
        
        self.navigationController?.popViewController(animated: true)
        
        // 게시물 수정 api 아직 뭔가....이해가 안되는..그런...
//        let imageUrl = appDelegate.baseUrl + "/board/board-img/" + String(boardInfo!.boardIdx)
//
//        AF.request(contentUrl,
//                   method: .post,
//                   parameters: [
//                    "imgUrl":
//                   ],
//                   encoding: JSONEncoding.default,
//                   headers: header
//        ).responseJSON{ response in
//            print("게시글 수정 결과")
//            print(response)
//        }
        
        
    }

    var commands: [UIAction] = []
    let commandList: [String] = ["자유", "질문", "홍보", "거래"]
    var boardCategory: Int = 0
    
    func setBoardButton(){
        
        boardCategory = boardInfo!.category
        
        for (index, name) in commandList.enumerated() {
            let command = UIAction(title: name, handler: {_ in
                self.boardCategory = index
            })
            commands.append(command)
        }
        
        choiceBoardBtn.menu = UIMenu(options: .singleSelection, children: commands)
        
        self.choiceBoardBtn.showsMenuAsPrimaryAction = true
        self.choiceBoardBtn.changesSelectionAsPrimaryAction = true
        
        var configuration = UIButton.Configuration.plain()
        
        let imageConfig = UIImage.SymbolConfiguration(weight: .light)
        
        configuration.image = UIImage(systemName: "chevron.down", withConfiguration: imageConfig)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 6, trailing: 0)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 10
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.foregroundColor = UIColor.white
            outgoing.font = UIFont.boldSystemFont(ofSize: 20)
            return outgoing
        }
        
        choiceBoardBtn.configuration = configuration
        choiceBoardBtn.tintColor = .white
        choiceBoardBtn.setTitle(commandList[boardCategory], for: .normal)
        
    }
    
    func setLayout(){
        self.title = "게시물 수정"
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setBoardButton()
        
        titleTextField.borderStyle = .none
        titleTextField.layer.cornerRadius = 15
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "제목",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)]
        )
        titleTextField.delegate = self
        titleTextField.text = boardInfo?.title
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 42))
        titleTextField.leftView = paddingView
        titleTextField.rightView = paddingView
        titleTextField.leftViewMode = .always
        titleTextField.rightViewMode = .always
        
        descriptionTextView.layer.cornerRadius = 15
        descriptionTextView.text = boardInfo?.content
        descriptionTextView.textColor = UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        descriptionTextView.delegate = self
        
        // 원래 있던 이미지 넣기
        let imgUrls = boardInfo!.getBoardImgs
        
        for imgInfo in imgUrls {
            let url = URL(string: imgInfo.imgUrl)
            do {
                let imgData = try Data(contentsOf: url!)
                postImgArr.append(UIImage(data: imgData)!)
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        imgPicker.delegate = self
        
        titleTextField.delegate = self
        descriptionTextView.delegate = self
    }
}

extension ModifyPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            if nullImg{
                nullImg = false
                postImgArr[0] = image
                postImgArr.append(UIImage())
            }else{
                postImgArr[postImgArr.count - 1] = image
                
                if(postImgArr.count < 5){
                    postImgArr.append(UIImage())
                }
            }
            
            collectionView.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension ModifyPostViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return postImgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostImageCollectionViewCell", for: indexPath) as! AddPostImageCollectionViewCell
        
        cell.layer.cornerRadius = 15
        
        cell.postImgView.image = postImgArr[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: nil, message: "이미지", preferredStyle: .actionSheet)
        
        let addAction = UIAlertAction(title: "추가하기", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
            self.addImage()
            })
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive, handler: {
                    (alert: UIAlertAction!) -> Void in
            self.deleteImage(targetIdx: indexPath.row)
                })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
              })
        
        optionMenu.addAction(addAction)
        if(postImgArr[indexPath.row] != UIImage()){
            optionMenu.addAction(deleteAction)
        }
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func addImage(){
        imgPicker.sourceType = .photoLibrary
        present(imgPicker, animated: true, completion: nil)
    }
    
    func deleteImage(targetIdx: Int){
        var isFull: Bool = false
        
        if(postImgArr.count == 5){
            if(postImgArr[4] != UIImage()){
                isFull = true
            }
        }
        
        if(postImgArr.count == 2){
            self.nullImg = true
        }
        postImgArr.remove(at: targetIdx)
        print(postImgArr.count)
        
        if (isFull){
            postImgArr.append(UIImage())
        }
        
        collectionView.reloadData()
    }
    
}

extension ModifyPostViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

extension ModifyPostViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.text == "게시물의 내용을 입력해주세요."{
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty{
            textView.text = "게시물의 내용을 입력해주세요."
            textView.textColor = UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)
        }
    }
    
}

extension ModifyPostViewController: UITextFieldDelegate{
    //화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
    //리턴 버튼 터치시 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
}


