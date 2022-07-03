//
//  LoginViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/03.
//

import UIKit

class LoginViewController: UIViewController{
    
    @IBOutlet weak var backgroundImg: UIImageView!
    
    func setLayout(){
        backgroundImg.largeContentImageInsets
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
}
