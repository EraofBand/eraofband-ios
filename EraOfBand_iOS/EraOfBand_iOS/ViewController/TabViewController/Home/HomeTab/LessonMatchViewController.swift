//
//  LessonMatchViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/23.
//

import UIKit

class LessonMatchViewController: UIViewController {

    @IBOutlet weak var choiceCityButton: UIButton!
    
    func setCityButton() {
        
        var commands: [UIAction] = []
        let commandList: [String] = ["전체", "서울", "경기도"]
        
        for name in commandList {
            let command = UIAction(title: name, handler: {_ in
                print("name: \(name)")                
            })
            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCityButton()
        
    }
    

}
