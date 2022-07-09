//
//  MypageTabView.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/06.
//

import UIKit

class MypageTabViewController: UIViewController {
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var sessionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoView.layer.cornerRadius = 15
        sessionView.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }
    

}
