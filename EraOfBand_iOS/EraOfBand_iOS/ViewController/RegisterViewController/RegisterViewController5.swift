//
//  RegisterViewController5.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/05.
//

import UIKit

class RegisterViewController5: UIViewController{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    
    var sessionModel = SessionModel.fetchMember()
    
    var myRegisterData: RegisterData!
    var selectedSession:Int = -1
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController6") as? RegisterViewController6 else {return}
        nextVC.myRegisterData = myRegisterData
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func setLayout(){
        
        let text = titleLabel.text
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1) as Any, range: (text! as NSString).range(of: "희망하는 세션"))
        
        titleLabel.attributedText = attributedString
         
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "희망하는 세션을 선택해주세요"
        
        setLayout()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        nextBtn.isEnabled = false

    }

}

extension RegisterViewController5: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sessionModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionCollectionViewCell", for: indexPath) as! SessionCollectionViewCell
        
        let session = sessionModel[indexPath.item]
        cell.sessionModel = session
        
        if selectedSession == indexPath.row{
            cell.checkBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            cell.checkBtn.tintColor = UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1)
            cell.nameLabel.textColor = UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1)
            cell.iconBorderView.layer.borderColor = UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1).cgColor
            myRegisterData.setSession(newSession: indexPath.row)
            
            print(myRegisterData.userSession)
        }else{
            cell.checkBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            cell.checkBtn.tintColor = UIColor.white
            cell.nameLabel.textColor = UIColor.white
            cell.iconBorderView.layer.borderColor = UIColor.white.cgColor
        }
        
        return cell
    }
}

extension RegisterViewController5: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95, height: 126)
    }
}

extension RegisterViewController5: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionCollectionViewCell", for: indexPath) as! SessionCollectionViewCell
        cell.checkBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        cell.checkBtn.tintColor = UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1)
        
        myRegisterData.setSession(newSession: indexPath.row)
        */
        
        selectedSession = indexPath.row
        self.collectionView.reloadData()
        self.nextBtn.isEnabled = true
    }
}
