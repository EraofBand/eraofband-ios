//
//  AddPostViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/18.
//

import UIKit
import Alamofire

class AddPostViewController: UIViewController{
    
    @IBOutlet weak var choiceBoardBtn: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var postImgArr: [UIImage] = [UIImage()]
    var imgUrlArr: [[String: String]] = [["imgUrl": ""]]
    var nullImg = true
    let imgPicker = UIImagePickerController()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func generateBtnTapped(_ sender: Any) {
        var category = 0
        switch(boardName){
        case "자유":
            category = 0
            break;
        case "질문":
            category = 1
            break;
        case "홍보":
            category = 2
        default:
            category = 3
        }
        
        var numOfImg = 0
        if(postImgArr.count == 5 && postImgArr[4] != UIImage()){
            numOfImg = 5
        }else{
            numOfImg = postImgArr.count - 1
        }
        
        if (numOfImg == 0){
            let header : HTTPHeaders = [
                "x-access-token": self.appDelegate.jwt,
                "Content-Type": "application/json"]
            
            AF.request(self.appDelegate.baseUrl + "/board",
                       method: .post,
                       parameters: [
                        "category": category,
                        "content": self.descriptionTextView.text ?? "",
                        "postImgsUrl": imgUrlArr,
                        "title": self.titleTextField.text ?? "",
                        "userIdx": self.appDelegate.userIdx!
                       ],
                       encoding: JSONEncoding.default,
                       headers: header
            ).responseJSON{ response in
                print("게시글 업로드 결과")
                print(response)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
        for i in 0..<numOfImg{
            PostUserService.getImgUrl(postImgArr[i]){ (isSuccess, result) in
                if isSuccess{
                    if(i==0){
                        self.imgUrlArr[0] = ["imgUrl": result]
                    }else{
                        self.imgUrlArr.append(["imgUrl": result])
                    }
                    print(self.imgUrlArr)
                    
                    if(i == (numOfImg - 1)){
                        let header : HTTPHeaders = [
                            "x-access-token": self.appDelegate.jwt,
                            "Content-Type": "application/json"]
                        
                        AF.request(self.appDelegate.baseUrl + "/board",
                                   method: .post,
                                   parameters: [
                                    "category": category,
                                    "content": self.descriptionTextView.text ?? "",
                                    "postImgsUrl": self.imgUrlArr,
                                    "title": self.titleTextField.text ?? "",
                                    "userIdx": self.appDelegate.userIdx!
                                   ],
                                   encoding: JSONEncoding.default,
                                   headers: header
                        ).responseJSON{ response in
                            print("게시글 업로드 결과")
                            print(response)
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            }
        }
    }
    
    var boardName: String = "자유"
    
    func setBoardButton(){
        var commands: [UIAction] = []
        let commandList: [String] = ["자유", "질문", "홍보", "거래"]
        
        for name in commandList {
            let command = UIAction(title: name, handler: {_ in
                self.boardName = name
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
    }
    
    func setLayout(){
        self.title = "게시물 생성"
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setBoardButton()
        
        titleTextField.borderStyle = .none
        titleTextField.layer.cornerRadius = 15
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "제목",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)]
        )
        titleTextField.delegate = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 42))
        titleTextField.leftView = paddingView
        titleTextField.rightView = paddingView
        titleTextField.leftViewMode = .always
        titleTextField.rightViewMode = .always
        
        descriptionTextView.layer.cornerRadius = 15
        descriptionTextView.text = "게시물의 내용을 입력해주세요."
        descriptionTextView.textColor = UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        descriptionTextView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        imgPicker.delegate = self
    }
}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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

extension AddPostViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
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

extension AddPostViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

extension AddPostViewController: UITextViewDelegate{
    
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

extension AddPostViewController: UITextFieldDelegate{
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
