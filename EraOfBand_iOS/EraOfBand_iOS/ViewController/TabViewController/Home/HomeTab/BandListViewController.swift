//
//  BandListViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/25.
//

import UIKit

class BandListViewController: UIViewController {
    
    @IBOutlet weak var choiceCityButton: UIButton!
    @IBOutlet weak var sessionChoiceCollectionView: UICollectionView!
    @IBOutlet weak var bandListTableView: UITableView!
    
    var session: [String] = ["전체", "보컬", "기타", "베이스", "키보드", "드럼"]
    var region: String = "전체"
    var bandList: [bandInfo] = []
    var sessionNum: Int = 5
    
    /* 지역 선택 버튼 설정 */
    func setCityButton() {
        
        var commands: [UIAction] = []
        let commandList: [String] = ["전체", "서울", "경기도"]
        
        for name in commandList {
            let command = UIAction(title: name, handler: {_ in
                print("name: \(name)")
                
                self.region = name
                self.getBandList()
                
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
    
    /* 네비게이션 바 커스텀 */
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
    
    /* 네비게이션 바 찾기 버튼 눌렀을 때 함수 */
    @objc func searchButtonClicked(_ sender: UIButton) {
        
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeSearch") as! SearchViewController
        searchVC.currentSearch = "band"
        
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    /* 밴드 리스트 불러오는 함수 */
    func getBandList() {
        
        GetBandListService.getBandInfoList(region, String(sessionNum)) { [self] (isSuccess, response) in
            if isSuccess {
                bandList = response.result
                
                bandListTableView.delegate = self
                bandListTableView.dataSource = self
                
                bandListTableView.reloadData()
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        
        setCityButton()
        
        getBandList()
        
        sessionChoiceCollectionView.delegate = self
        sessionChoiceCollectionView.dataSource = self
    }

}

extension BandListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return session.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionChoiceCollectionViewCell", for: indexPath) as! SessionChoiceCollectionViewCell
        
        cell.sessionLabel.text = session[indexPath.item]
        cell.layer.cornerRadius = 14
        
        if indexPath.item == sessionNum {
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
        
        getBandList()
        
    }
    
}

extension BandListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.width / 7
        
        return CGSize(width: width, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 3
    }
    
}

extension BandListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bandList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BandListTableViewCell", for: indexPath) as! BandListTableViewCell
        
        cell.backgroundColor = .clear
        
        let bandinfo = bandList[indexPath.item]
        let url = URL(string: bandinfo.bandImgUrl)!
        cell.tableImageView.load(url: url)
        cell.tableImageView.contentMode = .scaleAspectFill
        cell.tableRegionLabel.text = bandinfo.bandRegion
        cell.tableTitleLabel.text = bandinfo.bandTitle
        cell.tableIntroLabel.text = bandinfo.bandIntroduction
        cell.memberNumLabel.text = String(bandinfo.memberCount) + " / " + String(bandinfo.capacity)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bandRecruitVC = self.storyboard?.instantiateViewController(withIdentifier: "BandRecruitViewController") as? BandRecruitViewController else { return }
        
        GetBandInfoService.getBandInfo(bandList[indexPath.row].bandIdx){ [self]
            (isSuccess, response) in
            if isSuccess{
                bandRecruitVC.bandInfo = response.result
                bandRecruitVC.bandIdx = bandList[indexPath.row].bandIdx
                
                self.navigationController?.pushViewController(bandRecruitVC, animated: true)
            }
        }
    }

}
