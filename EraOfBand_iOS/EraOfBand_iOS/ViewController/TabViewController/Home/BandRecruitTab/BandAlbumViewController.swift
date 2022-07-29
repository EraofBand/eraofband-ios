//
//  BandAlbumViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/29.
//

import UIKit
import Kingfisher

class BandAlbumViewController: UIViewController{
    @IBOutlet weak var albumImageView: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumImageView.layer.cornerRadius = 10
        
        albumImageView.kf.setImage(with: URL(string: appDelegate.currentBandInfo?.bandImgUrl ?? ""))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
}
