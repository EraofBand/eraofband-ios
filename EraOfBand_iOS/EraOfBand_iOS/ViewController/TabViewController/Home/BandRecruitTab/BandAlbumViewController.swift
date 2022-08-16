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
    
    var bandInfo: BandInfoResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        albumImageView.layer.cornerRadius = 10
        
        albumImageView.kf.setImage(with: URL(string: bandInfo?.bandImgUrl ?? ""))
    }
}
