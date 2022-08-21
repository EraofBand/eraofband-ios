//
//  RegisterViewController7.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/21.
//

import UIKit
import Alamofire

class RegisterViewController7: UIViewController{

    @IBOutlet weak var titleLabel: UILabel!
    var myRegisterData: RegisterData!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startBtnTapped(_ sender: Any) {
        guard let mainTabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as? TabBarController else {return}
        mainTabBarVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
    
        self.present(mainTabBarVC, animated: true)
    }
    func setLayout(){
        let text = myRegisterData.nickName + "님\n밴드의 시대에 오신 것을\n진심으로 환영합니다!"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white as Any, range: (text as NSString).range(of: "님\n밴드의 시대에 오신 것을\n진심으로 환영합니다!"))
        
        titleLabel.attributedText = attributedString

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
    }
}
