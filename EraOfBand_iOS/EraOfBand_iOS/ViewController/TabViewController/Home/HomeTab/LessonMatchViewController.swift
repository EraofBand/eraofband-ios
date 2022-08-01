//
//  LessonMatchViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/23.
//

import UIKit

class LessonMatchViewController: UIViewController {

    @IBOutlet weak var choiceCityButton: UIButton!
    @IBOutlet weak var sessionChoiceCollectionView: UICollectionView!
    @IBOutlet weak var LessonListTableView: UITableView!
    
    var session: [String] = ["전체", "보컬", "기타", "베이스", "키보드", "드럼"]
    var region: String = "전체"
    var lessonList: [lessonInfo] = []
    var sessionNum: Int = 5
    
    func setCityButton() {
        
        var commands: [UIAction] = []
        let commandList: [String] = ["전체", "서울", "경기도"]
        
        for name in commandList {
            let command = UIAction(title: name, handler: {_ in
                print("name: \(name)")
                
                self.region = name
                self.getLessonList()
                
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
    
    func getLessonList() {
        
        GetLessonListService.getLessonInfoList(region, String(sessionNum)) { [self] (isSuccess, response) in
            if isSuccess {
                lessonList = response.result
                
                LessonListTableView.delegate = self
                LessonListTableView.dataSource = self
                
                LessonListTableView.reloadData()
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCityButton()
        
        getLessonList()
        
        sessionChoiceCollectionView.delegate = self
        sessionChoiceCollectionView.dataSource = self
        
    }
    

}

extension LessonMatchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return session.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionChoiceCollectionViewCell", for: indexPath) as! SessionChoiceCollectionViewCell
        
        cell.sessionLabel.text = session[indexPath.item]
        cell.layer.cornerRadius = 14
        
        if indexPath.item == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item != 0 {
            sessionNum = indexPath.item - 1
        } else {
            sessionNum = 5
        }
        
        print("selected index: \(sessionNum)")
        
        getLessonList()
        
    }
    
}

extension LessonMatchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 50, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 3
    }
    
}

extension LessonMatchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BandListTableViewCell", for: indexPath) as! BandListTableViewCell
        
        cell.backgroundColor = .clear
        
        let lessoninfo = lessonList[indexPath.item]
        let url = URL(string: lessoninfo.lessonImgUrl)!
        cell.tableImageView.load(url: url)
        cell.tableImageView.contentMode = .scaleAspectFill
        cell.tableRegionLabel.text = lessoninfo.lessonRegion
        cell.tableTitleLabel.text = lessoninfo.lessonTitle
        cell.tableIntroLabel.text = lessoninfo.lessonIntroduction
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lessonRecruitVC = self.storyboard?.instantiateViewController(withIdentifier: "LessonRecruitViewController") as? LessonRecruitViewController else { return }
        
        GetLessonInfoService.getLessonInfo(lessonList[indexPath.row].lessonIdx){ [self]
            (isSuccess, response) in
            if isSuccess{
                lessonRecruitVC.lessonInfo = response.result
                lessonRecruitVC.lessonIdx = lessonList[indexPath.row].lessonIdx

                self.navigationController?.pushViewController(lessonRecruitVC, animated: true)
            }
        }
    }

}
