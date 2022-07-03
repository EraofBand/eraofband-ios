//
//  OnboardingViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/03.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    
    /*스킵 버튼 눌렀을 때 로그인 뷰로 이동*/
    @IBAction func skipBtnTapped(_ sender: Any) {
        
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
        loginVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        self.present(loginVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
