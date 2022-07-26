//
//  BandListViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/25.
//

import UIKit

class BandListViewController: UIViewController {
    
    @IBOutlet weak var choiceCityButton: UIButton!
    
    func setCityButton() {
        
        var commands: [UIAction] = []
        let commandList: [String] = ["전체", "서울", "경기도"]
        
        for name in commandList {
            let command = UIAction(title: name, handler: {_ in print("name: \(name)")})
            
            commands.append(command)
        }
        
        choiceCityButton.menu = UIMenu(options: .singleSelection, children: commands)
        
        self.choiceCityButton.showsMenuAsPrimaryAction = true
        self.choiceCityButton.changesSelectionAsPrimaryAction = true
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 10
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.foregroundColor = UIColor.white
            outgoing.font = UIFont.boldSystemFont(ofSize: 20)
            return outgoing
        }
        
        choiceCityButton.configuration = configuration
        choiceCityButton.tintColor = .white
        
    }
    
    @objc func refreshData() {
        
    }
    
    func setNavigationBar() {
        
        self.navigationItem.title = "생성된 밴드 목록"
        
        var rightBarButtons: [UIBarButtonItem] = []
        
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
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                             target: nil, action: nil)
        negativeSpacer.width = 15
        
        rightBarButtons.append(negativeSpacer)
        rightBarButtons.append(searchBarButton)
        
        self.navigationItem.rightBarButtonItems = rightBarButtons
        
    }
    
    @objc func searchButtonClicked(_ sender: UIButton) {
        
        print("찾기 버튼 누름")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        
        setCityButton()
        
    }

}
