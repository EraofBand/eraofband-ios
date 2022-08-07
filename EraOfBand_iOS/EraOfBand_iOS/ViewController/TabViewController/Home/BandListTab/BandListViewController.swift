//
//  BandListViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/25.
//

import UIKit

class BandListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
    }
    
    func setNavigationBar() {
        
        self.navigationItem.title = "생성된 밴드 목록"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let searchImage = UIImage(named: "ic_search")
        let searchButton = UIButton()
        searchButton.backgroundColor = .clear
        searchButton.setImage(searchImage, for: .normal)
        searchButton.addTarget(self, action: #selector(self.searchButtonClicked), for: .touchUpInside)
        
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        let currWidth = searchBarButton.customView?.widthAnchor.constraint(equalToConstant: 20)
        currWidth?.isActive = true
        let currheight = searchBarButton.customView?.heightAnchor.constraint(equalToConstant: 20)
        currheight?.isActive = true
        
        self.navigationItem.rightBarButtonItem = searchBarButton
        
    }
    
    @objc func searchButtonClicked() {
        
        print("검색 눌럿다~")
        
    }
    


}
